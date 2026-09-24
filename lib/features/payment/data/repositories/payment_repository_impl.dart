import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:parkir_digital_bapenda/core/storage/i_secure_storage_manager.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/payment_success_entity.dart';
import '../../domain/repositories/i_payment_repository.dart';
import '../datasources/qris_signalr_datasource.dart';

@LazySingleton(as: IPaymentRepository)
class PaymentRepositoryImpl implements IPaymentRepository {
  final QrisSignalRDatasource _signalRDatasource;
  final ISecureStorageManager _iSecureStorageManager;

  PaymentRepositoryImpl(this._signalRDatasource, this._iSecureStorageManager);

  @override
  Future<Either<Failure, Unit>> connectToPaymentStream(String kodeQris) async {
    try {
      await _signalRDatasource.connectAndJoin(kodeQris);
      return const Right(unit);
    } catch (e) {
      return Left(
        ServerFailure('Gagal terhubung ke server pembayaran: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> disconnectPaymentStream() async {
    try {
      await _signalRDatasource.disconnect();
      return const Right(unit);
    } catch (e) {
      return const Left(ServerFailure('Gagal memutus koneksi dengan aman.'));
    }
  }

  @override
  Stream<Either<Failure, PaymentSuccessEntity>> getPaymentStatusStream() {
    // PERBAIKAN KRUSIAL: sebelumnya ini `async*` + `await for`. Masalahnya,
    // generator `async*` yang membungkus stream LAIN (dalam kasus ini
    // stream broadcast dari QrisSignalRDatasource) punya sifat berbahaya
    // di Dart: kalau downstream listener memanggil `.cancel()`, generator
    // baru benar-benar berhenti (Future dari cancel() baru resolve) SAAT
    // stream sumbernya mengirim event BERIKUTNYA — karena generator
    // sedang "tertidur" di `await for`, menunggu item baru, dan baru di
    // situ dia sempat mengecek bahwa dirinya sudah di-cancel.
    //
    // Ini jadi bug nyata di alur kita: begitu QRIS_TIMEOUT lokal/server
    // terjadi, kita memutus SignalR (disconnect()) SEBELUM proses
    // cancel() ini sempat selesai wajar. Karena sumber event-nya sudah
    // mati total, generator tidak akan PERNAH menerima event lagi untuk
    // "membangunkannya" — Future dari cancel() hang selamanya, dan
    // `await _signalRSubscription?.cancel();` di PaymentCubit ikut hang,
    // menyumbat seluruh alur reconnect berikutnya.
    //
    // `.asyncMap()` tidak punya masalah ini — dia StreamTransformer
    // standar (bukan async* + await-for), jadi cancel() diteruskan
    // langsung ke stream sumber tanpa perlu menunggu event berikutnya.
    return _signalRDatasource.qrisStatusStream.asyncMap(_mapSignalREvent);
  }

  Future<Either<Failure, PaymentSuccessEntity>> _mapSignalREvent(
    SignalREvent event,
  ) async {
    if (event.status == "LUNAS") {
      try {
        final payload = event.payload ?? {};
        final profileOP = await _iSecureStorageManager.getJukirProfile();
        final namaOpValue = profileOP?['namaObjekPajak']?.toString() ?? '-';
        final alamatOpValue = profileOP?['alamat']?.toString() ?? '-';

        final entity = PaymentSuccessEntity(
          orderId: payload['orderId']?.toString() ?? '-',
          namaOp: namaOpValue,
          alamatOp: alamatOpValue,
          tanggalTransaksi:
              payload['tanggalTransaksi']?.toString() ??
              DateTime.now().toIso8601String(),
          jenisTarif: payload['jenisTarif']?.toString() ?? '-',
          credit: (double.tryParse(payload['amount']?.toString() ?? '0') ?? 0)
              .toInt(),
          encUrl: payload['neCurl']?.toString() ?? '',
        );

        return Right(entity);
      } catch (e) {
        // FALLBACK TERAKHIR: Jika terjadi error parsing ekstrem (misal format JSON berubah),
        // TETAP pancarkan Right(Entity) dengan data kosong, agar flow LUNAS tidak putus!
        return Right(
          PaymentSuccessEntity(
            orderId: '-',
            namaOp: '-',
            alamatOp: '-',
            tanggalTransaksi: DateTime.now().toIso8601String(),
            jenisTarif: '-',
            credit: 0,
            encUrl: '',
          ),
        );
      }
    } else if (event.status == "TIMEOUT") {
      return const Left(ServerFailure('TIMEOUT'));
    } else if (event.status == "ERROR") {
      return const Left(ServerFailure('ERROR'));
    } else if (event.status == "DISCONNECTED") {
      // BARU: koneksi putus permanen (auto-reconnect SignalR sudah habis
      // mencoba). Pesan ini sengaja dibedakan dari "ERROR" biasa supaya
      // PaymentCubit bisa menampilkan pesan yang lebih tepat ke user
      // ("koneksi terputus" vs "transaksi gagal").
      return const Left(ServerFailure('DISCONNECTED'));
    }

    // Defensif: status yang belum kita kenal (mis. penambahan status baru
    // di masa depan). Sebelumnya (versi async*) status semacam ini akan
    // hilang begitu saja (tidak pernah di-yield). Sekarang tetap
    // diteruskan sebagai Failure generik supaya tidak pernah "hilang
    // diam-diam" — PaymentCubit sudah punya cabang `else` yang menangani
    // failure.message apapun.
    return Left(ServerFailure(event.status));
  }
}
