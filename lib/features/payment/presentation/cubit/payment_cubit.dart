import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:parkir_digital_bapenda/core/utils/app_logger.dart';
import 'package:parkir_digital_bapenda/features/transaction/domain/usecases/qris_usecase.dart';
import '../../domain/constant/qris_contants.dart';
import '../../domain/usecases/payment_usecase.dart';
import 'payment_state.dart';

@injectable
class PaymentCubit extends Cubit<PaymentState> {
  final QrisUsecase _qrisUsecase;
  final PaymentUseCase _paymentUsecase;

  StreamSubscription? _signalRSubscription;

  PaymentCubit(this._qrisUsecase, this._paymentUsecase)
    : super(const PaymentState.initial());

  Future<void> loadQris({
    required int jenisKendaraanId,
    required bool isDemoMode,
    bool isRetryFetch = false,
  }) async {
    if (isClosed) return;

    // INSTRUMENTASI DIAGNOSTIK — sengaja verbose sementara untuk melacak
    // kasus "Coba Lagi tidak trigger reconnect SignalR sama sekali".
    // Boleh dikurangi/rapikan lagi setelah root cause ketemu.
    AppLogger.debug(
      '🔍 [PaymentCubit] loadQris() dipanggil — jenisKendaraanId=$jenisKendaraanId, '
      'isDemoMode=$isDemoMode, isRetryFetch=$isRetryFetch',
    );

    emit(const PaymentState.loading());

    if (isDemoMode) {
      final qrisString = QrisDemoConstants.getQrisByVehicleType(
        jenisKendaraanId,
      );
      if (!isClosed) {
        emit(PaymentState.demoQrisReady(rawQrisString: qrisString));
      }
      return;
    }

    AppLogger.debug('🔍 [PaymentCubit] Memanggil getLocalQris()...');
    final result = await _qrisUsecase.getLocalQris();
    if (isClosed) return;

    await result.fold(
      (failure) async {
        AppLogger.debug(
          '🔍 [PaymentCubit] getLocalQris() GAGAL: ${failure.message} '
          '(isRetryFetch=$isRetryFetch)',
        );
        if (!isRetryFetch) {
          await _forceSyncAndReload(jenisKendaraanId, isDemoMode);
        } else {
          emit(
            const PaymentState.error(
              message: 'Gagal mengunduh data QRIS. Pastikan internet stabil.',
            ),
          );
        }
      },
      (qrisMap) async {
        if (isClosed) return;

        AppLogger.debug(
          '🔍 [PaymentCubit] getLocalQris() SUKSES — keys tersedia: '
          '${qrisMap.keys.toList()}',
        );

        final qrisEntity = qrisMap[jenisKendaraanId.toString()];

        if (qrisEntity == null ||
            qrisEntity.path.isEmpty ||
            !File(qrisEntity.path).existsSync()) {
          AppLogger.debug(
            '🔍 [PaymentCubit] Entity untuk jenisKendaraanId=$jenisKendaraanId '
            'null/path kosong/file tidak ada. entity=$qrisEntity '
            '(isRetryFetch=$isRetryFetch)',
          );
          if (!isRetryFetch) {
            await _forceSyncAndReload(jenisKendaraanId, isDemoMode);
            return;
          }
          emit(
            const PaymentState.error(
              message: 'File gambar QRIS rusak atau hilang.',
            ),
          );
          return;
        }

        String simulatedKodeQris = qrisEntity.kodeQris;

        AppLogger.debug(
          '🔍 [PaymentCubit] Entity OK — kodeQris="$simulatedKodeQris" '
          '(panjang: ${simulatedKodeQris.length}), path=${qrisEntity.path}',
        );

        emit(
          PaymentState.localQrisReady(
            qrisImagePath: qrisEntity.path,
            kodeQris: simulatedKodeQris,
          ),
        );

        if (simulatedKodeQris.trim().isNotEmpty) {
          AppLogger.debug(
            '🔍 [PaymentCubit] kodeQris tidak kosong -> memanggil _setupSignalR()',
          );
          await _setupSignalR(qrisEntity.kodeQris);
        } else {
          // INI KANDIDAT UTAMA BUG "stuck tanpa reconnect": kalau baris
          // ini yang muncul di log saat "Coba Lagi" ditekan, berarti
          // SignalR memang SENGAJA tidak pernah dipanggil karena
          // kodeQris dari getLocalQris() sudah kosong di percobaan ini.
          AppLogger.error(
            '⚠️ [PaymentCubit] kodeQris KOSONG setelah loadQris() — '
            'SignalR TIDAK akan dibuka. jenisKendaraanId=$jenisKendaraanId, '
            'isRetryFetch=$isRetryFetch',
          );
        }
      },
    );
  }

  Future<void> _forceSyncAndReload(
    int jenisKendaraanId,
    bool isDemoMode,
  ) async {
    AppLogger.debug(
      '🔍 [PaymentCubit] _forceSyncAndReload() dipanggil — memanggil syncQris()...',
    );
    final syncResult = await _qrisUsecase.syncQris();

    if (isClosed) return;

    syncResult.fold(
      (failure) {
        AppLogger.debug(
          '🔍 [PaymentCubit] syncQris() GAGAL: ${failure.message}',
        );
        emit(PaymentState.error(message: 'Koneksi gagal: ${failure.message}'));
      },
      (_) async {
        AppLogger.debug(
          '🔍 [PaymentCubit] syncQris() SUKSES — memanggil ulang loadQris() '
          'dengan isRetryFetch=true',
        );
        await loadQris(
          jenisKendaraanId: jenisKendaraanId,
          isDemoMode: isDemoMode,
          isRetryFetch: true,
        );
      },
    );
  }

  Future<void> _setupSignalR(String kodeQris) async {
    AppLogger.debug(
      '🔍 [PaymentCubit] _setupSignalR() MASUK, kodeQris=$kodeQris',
    );

    // Catatan: cancel() di sini aman — ini cancel subscription LAMA milik
    // cubit yang SAMA (retry/ganti kendaraan tanpa pindah halaman), bukan
    // lintas-instance, jadi tidak ada race lintas cubit di titik ini.
    await _signalRSubscription?.cancel();

    _signalRSubscription = _paymentUsecase.statusStream.listen((result) {
      if (isClosed) return;

      result.fold(
        (failure) {
          if (failure.message == "TIMEOUT") {
            emit(
              const PaymentState.error(
                message: 'Waktu pembayaran habis (Silahkan Ulangi).',
              ),
            );
          } else if (failure.message == "DISCONNECTED") {
            // BARU (Poin 2): auto-reconnect SignalR sudah habis mencoba
            // dan koneksi putus permanen. Reuse PaymentState.error yang
            // sudah ada — tombol "Coba Lagi" di UI otomatis memanggil
            // loadQris() lagi, yang akan membuka koneksi baru dari awal.
            emit(
              const PaymentState.error(
                message:
                    'Koneksi terputus. Silakan tekan "Coba Lagi" untuk '
                    'menyambung ulang.',
              ),
            );
          } else {
            emit(PaymentState.error(message: failure.message));
          }
        },
        (ticketData) {
          emit(PaymentState.paymentSuccess(ticketData: ticketData));
        },
      );
    });

    // Panggil connect() SETELAH listen() di atas (urutan ini sengaja
    // dipertahankan) — connect() -> connectAndJoin() di datasource akan
    // memanggil disconnect() sebagai baris pertamanya, yang menaikkan
    // generation token secara sinkron. Karena tidak ada `await` sungguhan
    // di antara listen() dan baris di bawah ini, tidak ada celah bagi
    // event dari koneksi lama untuk "nyasar" ke listener yang baru saja
    // dipasang.
    AppLogger.debug('🔍 [PaymentCubit] Memanggil _paymentUsecase.connect()...');
    final connectResult = await _paymentUsecase.connect(kodeQris);

    if (isClosed) return;

    connectResult.fold(
      (failure) {
        AppLogger.debug(
          '🔍 [PaymentCubit] connect() GAGAL (return value): ${failure.message}',
        );
        emit(PaymentState.error(message: failure.message));
      },
      (_) {
        AppLogger.debug(
          '🔍 [PaymentCubit] connect() SUKSES (return value) — menunggu event stream',
        );
        // Sukses terhubung, biarkan listener Stream yang bekerja
      },
    );
  }

  /// BARU (Poin 4): dipanggil dari PaymentPage saat app kembali ke
  /// foreground (AppLifecycleState.resumed). Tidak mencoba menebak-nebak
  /// apakah koneksi masih hidup atau tidak — selama halaman masih dalam
  /// keadaan menampilkan QR aktif (`localQrisReady`), langsung minta
  /// koneksi baru. connectAndJoin() di datasource sudah aman dipanggil
  /// berulang: ia selalu disconnect() dulu (generation-guarded) sebelum
  /// membangun koneksi baru, jadi tidak akan pernah dobel-konek walau
  /// koneksi lama sebenarnya masih hidup.
  ///
  /// Sengaja TIDAK melakukan pengecekan kedaluwarsa timer di sini (Opsi A
  /// yang disepakati) — kalau QR sudah lewat waktu, alur timeout yang
  /// sudah ada (PaymentCountdownTimer -> QRIS_TIMEOUT) yang menangani.
  void reconnectIfNeeded() {
    if (isClosed) return;
    state.whenOrNull(
      localQrisReady: (qrisImagePath, kodeQris) {
        if (kodeQris.trim().isNotEmpty) {
          _setupSignalR(kodeQris);
        }
      },
    );
  }

  /// BARU (Poin A - jaring pengaman): dipanggil dari PaymentCountdownTimer
  /// saat hitungan mundur LOKAL mencapai 00:00. Jalur UTAMA menuju
  /// PaymentState.error tetap event QRIS_TIMEOUT dari server lewat
  /// SignalR (tidak berubah). Method ini murni fallback terakhir —
  /// kalau karena sebab apapun SignalR tidak pernah tersambung ulang
  /// (bug reconnect yang sedang kita telusuri) atau server gagal/telat
  /// mengirim QRIS_TIMEOUT, timer lokal ini yang menjamin user tidak
  /// terjebak selamanya di layar yang sama tanpa tombol "Coba Lagi".
  ///
  /// Sengaja hanya bereaksi kalau state MASIH `localQrisReady` — kalau
  /// state sudah berubah ke `error`/`paymentSuccess` duluan (race wajar
  /// antara timer lokal dan event SignalR yang datang hampir bersamaan),
  /// method ini otomatis jadi no-op, tidak menimpa state yang sudah
  /// benar.
  void handleLocalTimeout() {
    if (isClosed) return;
    state.whenOrNull(
      localQrisReady: (qrisImagePath, kodeQris) {
        AppLogger.debug(
          '⏰ [PaymentCubit] Timer lokal mencapai 00:00 sementara state '
          'masih localQrisReady — SignalR kemungkinan tidak pernah kirim '
          'QRIS_TIMEOUT. Trigger fallback error.',
        );
        // Tangani cleanup di method terpisah yang di-await dengan benar
        // (lihat _cleanupSignalRAfterLocalTimeout) — sengaja TIDAK
        // di-await di sini karena handleLocalTimeout() dipanggil
        // langsung dari VoidCallback (onTimeout widget), yang harus
        // tetap synchronous. emit() langsung jalan supaya UI tidak
        // menunggu proses cleanup selesai dulu.
        _cleanupSignalRAfterLocalTimeout();
        emit(
          const PaymentState.error(
            message: 'Waktu pembayaran habis (Silahkan Ulangi).',
          ),
        );
      },
    );
  }

  /// Cleanup terpisah dari handleLocalTimeout() supaya urutannya benar:
  /// tangkap referensi subscription LAMA ke variabel lokal dan LANGSUNG
  /// null-kan field-nya SEBELUM benar-benar menunggu cancel() selesai.
  /// Ini penting: kalau _setupSignalR() berikutnya (dipicu tekan "Coba
  /// Lagi") sempat jalan sebelum cancel() ini selesai, dia akan melihat
  /// _signalRSubscription == null dan SKIP baris cancel()-nya sendiri —
  /// mencegah dua pemanggilan cancel() bertumpuk pada objek subscription
  /// yang sama.
  Future<void> _cleanupSignalRAfterLocalTimeout() async {
    final oldSubscription = _signalRSubscription;
    _signalRSubscription = null;
    await oldSubscription?.cancel();
    await _paymentUsecase.disconnect();
  }

  @override
  Future<void> close() async {
    // PERBAIKAN URUTAN: panggil disconnect() lebih dulu (tanpa langsung
    // di-await) sebelum cancel() subscription. Baris pertama di dalam
    // QrisSignalRDatasource.disconnect() adalah menaikkan generation
    // token secara SINKRON begitu dipanggil — jadi generation sudah
    // ter-invalidasi sebelum proses close() ini sempat menyerahkan
    // kendali ke event loop lewat `await cancel()`. Ini menutup celah
    // dimana koneksi lama masih dianggap "current" selama cancel()
    // sedang berjalan.
    final disconnectFuture = _paymentUsecase.disconnect();
    await _signalRSubscription?.cancel();
    await disconnectFuture;
    return super.close();
  }
}
