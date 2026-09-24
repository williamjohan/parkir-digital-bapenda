import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:signalr_netcore/signalr_client.dart';
import '../../../../core/utils/app_logger.dart';

/// Status yang mungkin dikirim lewat [QrisSignalRDatasource.qrisStatusStream]:
/// - "LUNAS"        : pembayaran sukses, `payload` berisi data transaksi
/// - "TIMEOUT"       : QRIS_TIMEOUT dari server (waktu pembayaran habis)
/// - "ERROR"         : QRIS_ERROR dari server, atau kegagalan connect awal
/// - "DISCONNECTED" : koneksi putus PERMANEN (auto-reconnect sudah habis
///                     mencoba) — beda dari "ERROR" karena ini soal
///                     jaringan/koneksi, bukan soal transaksi itu sendiri
class SignalREvent {
  final String status;
  final Map<String, dynamic>? payload;
  SignalREvent(this.status, {this.payload});
}

@lazySingleton
class QrisSignalRDatasource {
  HubConnection? _connection;

  StreamController<SignalREvent>? _statusController;
  String? _activeKodeQris;

  // NEW: generation token. Dinaikkan oleh connectAndJoin() DAN disconnect().
  // Ini krusial karena PaymentCubit dibuat ulang setiap kali route /payment
  // di-push (lihat BlocProvider di app_routes.dart), sementara datasource
  // ini @lazySingleton dan dipakai bergantian oleh cubit-cubit tersebut.
  // Tanpa bump di disconnect() juga, attempt lama dari Cubit yang sudah
  // close() masih bisa menembak event ke stream yang sedang didengarkan
  // Cubit baru — persis kasus "QRIS Tidak Tersedia" yang muncul tiba-tiba
  // tanpa ada log usaha connect baru.
  int _connectionGeneration = 0;

  Stream<SignalREvent> get qrisStatusStream {
    _statusController ??= StreamController<SignalREvent>.broadcast();
    return _statusController!.stream;
  }

  /// Buka koneksi dan join group kodeQris
  Future<void> connectAndJoin(String kodeQris) async {
    // Selalu bersihkan koneksi sebelumnya dulu, apapun statusnya.
    await disconnect();

    // Generation baru untuk percobaan koneksi ini.
    final int myGeneration = ++_connectionGeneration;
    _activeKodeQris = kodeQris;

    final HubConnection connection = HubConnectionBuilder()
        .withUrl("https://apibapenda.surabaya.go.id:8282/qrisHub")
        .withAutomaticReconnect()
        .build();

    // Simpan ke field HANYA setelah dibuat, tapi kita tetap pegang
    // referensi lokal `connection` untuk semua operasi di generation ini
    // supaya tidak ketuker sama koneksi generation lain.
    _connection = connection;

    _registerListeners(connection, myGeneration);

    try {
      await connection.start();

      // Kalau selama menunggu start() ada percobaan koneksi baru yang
      // lebih baru (user sudah pindah lagi), buang hasil ini dan jangan
      // lanjut join / log seolah-olah ini koneksi yang aktif.
      if (myGeneration != _connectionGeneration) {
        AppLogger.debug(
          '⚠️ [SignalR] Koneksi generation $myGeneration sudah usang, '
          'membersihkan diri diam-diam.',
        );
        await _stopSilently(connection);
        return;
      }

      AppLogger.debug('🟢 [SignalR] Connected! State: ${connection.state}');
      await _joinGroup(connection, kodeQris, myGeneration);
    } catch (e) {
      if (myGeneration != _connectionGeneration) {
        // Sudah usang, jangan kirim ERROR palsu ke listener yang sedang
        // menunggu koneksi generation baru.
        return;
      }
      AppLogger.error('🚨 [SignalR] Gagal connect: $e');
      _statusController?.add(SignalREvent("ERROR"));
    }
  }

  Future<void> _joinGroup(
    HubConnection connection,
    String kodeQris,
    int generation,
  ) async {
    try {
      if (connection.state == HubConnectionState.Connected) {
        await connection.invoke("QrisStatus", args: [kodeQris]);
        if (generation == _connectionGeneration) {
          AppLogger.debug('📡 [SignalR] Joined group: $kodeQris');
        }
      }
    } catch (e) {
      if (generation == _connectionGeneration) {
        AppLogger.error('❌ [SignalR] Gagal invoke QrisStatus: $e');
      }
    }
  }

  /// Event Listeners — sekarang menerima instance koneksi & generation-nya
  /// sendiri, bukan mengandalkan field `_connection` yang bisa berubah.
  void _registerListeners(HubConnection connection, int generation) {
    connection.on("QRIS_LUNAS", (arguments) {
      if (generation != _connectionGeneration) return; // abaikan zombie
      AppLogger.debug('💰 [SignalR] QRIS_LUNAS — args: $arguments');

      if (arguments != null && arguments.isNotEmpty) {
        try {
          final rawPayload = arguments[0] as Map<dynamic, dynamic>;
          final safePayload = rawPayload.map(
            (key, value) => MapEntry(key.toString(), value),
          );
          _statusController?.add(SignalREvent("LUNAS", payload: safePayload));
        } catch (e) {
          AppLogger.error('🚨 Gagal parsing payload LUNAS: $e');
          _statusController?.add(SignalREvent("LUNAS"));
        }
      } else {
        _statusController?.add(SignalREvent("LUNAS"));
      }
    });

    connection.on("QRIS_PENDING", (arguments) {
      if (generation != _connectionGeneration) return;
      AppLogger.debug('⏳ [SignalR] QRIS_PENDING — args: $arguments');
    });

    connection.on("QRIS_TIMEOUT", (arguments) {
      if (generation != _connectionGeneration) return;
      AppLogger.debug('⏰ [SignalR] QRIS_TIMEOUT — args: $arguments');
      _statusController?.add(SignalREvent("TIMEOUT"));
    });

    connection.on("QRIS_ERROR", (arguments) {
      if (generation != _connectionGeneration) return; // kunci utama fix ini
      AppLogger.debug('❌ [SignalR] QRIS_ERROR — args: $arguments');
      try {
        if (arguments != null && arguments.isNotEmpty) {
          final payload = arguments[0] as Map<dynamic, dynamic>?;
          if (payload != null && payload['status'] == 'PENDING') {
            AppLogger.debug(
              '🛡️ False Alarm ditahan! Status sebenarnya masih PENDING.',
            );
            return;
          }
        }
      } catch (e) {
        AppLogger.error('Gagal parsing error payload: $e');
      }
      _statusController?.add(SignalREvent("ERROR"));
    });

    connection.onreconnected(({connectionId}) async {
      if (generation != _connectionGeneration) return;
      AppLogger.debug('🔄 [SignalR] Reconnected — connectionId: $connectionId');
      if (_activeKodeQris != null) {
        await _joinGroup(connection, _activeKodeQris!, generation);
      }
    });

    connection.onclose(({error}) {
      // PENTING: cek generation di sini bukan cuma soal zombie listener.
      // disconnect() SELALU menaikkan generation SEBELUM memanggil
      // connection.stop() — jadi saat KITA yang sengaja memutus koneksi
      // (pindah halaman, ganti kendaraan, dsb.), onclose ini akan otomatis
      // ter-suppress di sini karena generation sudah tidak cocok lagi.
      //
      // Kalau generation MASIH cocok berarti koneksi ini mati BUKAN karena
      // kita yang memutusnya — artinya otomatis-reconnect bawaan SignalR
      // (withAutomaticReconnect, default retry di 0/2/10/30 detik) sudah
      // habis mencoba dan menyerah. Ini sinyal genuine "putus permanen"
      // yang perlu diteruskan ke UI, bukan cuma di-log.
      if (generation != _connectionGeneration) return;
      AppLogger.debug('🛑 [SignalR] Connection closed — error: $error');
      AppLogger.error(
        '🔌 [SignalR] Koneksi putus permanen (auto-reconnect sudah habis '
        'mencoba). Melapor ke UI.',
      );
      _statusController?.add(SignalREvent("DISCONNECTED"));
    });
  }

  /// Stop koneksi tanpa nge-log/ganggu state generation aktif — dipakai
  /// buat beresin koneksi yang sudah usang (superseded).
  Future<void> _stopSilently(HubConnection connection) async {
    try {
      connection.off("QRIS_LUNAS");
      connection.off("QRIS_PENDING");
      connection.off("QRIS_TIMEOUT");
      connection.off("QRIS_ERROR");
      await connection.stop();
    } catch (_) {
      // Diamkan — ini cuma best-effort cleanup koneksi usang.
    }
  }

  /// Close — sekarang membersihkan koneksi APAPUN statusnya, bukan cuma
  /// yang berstatus Connected. Ini yang tadinya bikin koneksi zombie.
  ///
  /// PENTING: generation juga di-bump di sini, bukan cuma di
  /// connectAndJoin(). Ini yang menutup celah "Cubit A close() duluan,
  /// lalu attempt connect() lama miliknya baru gagal/berhasil belakangan
  /// dan menembak event ke stream yang sedang didengarkan Cubit B".
  /// Begitu disconnect() dipanggil, attempt manapun yang masih pending
  /// otomatis dianggap usang oleh pengecekan `generation == _connectionGeneration`
  /// di connectAndJoin()/_joinGroup()/listener, walau attempt itu belum
  /// sempat memanggil connectAndJoin() baru sama sekali.
  Future<void> disconnect() async {
    _connectionGeneration++;

    final HubConnection? connection = _connection;
    _connection = null;
    _activeKodeQris = null;

    if (connection == null) return;

    try {
      connection.off("QRIS_LUNAS");
      connection.off("QRIS_PENDING");
      connection.off("QRIS_TIMEOUT");
      connection.off("QRIS_ERROR");

      if (connection.state != HubConnectionState.Disconnected) {
        await connection.stop();
      }
      AppLogger.debug('🛑 [SignalR] Disconnected');
    } catch (e) {
      // Koneksi yang masih dalam proses "Connecting" saat di-stop() bisa
      // saja melempar exception dari package-nya — jangan biarkan ini
      // merusak alur disconnect di pemanggil.
      AppLogger.error('⚠️ [SignalR] Error saat disconnect: $e');
    }
  }

  /// Dispose
  Future<void> dispose() async {
    await disconnect();
    await _statusController?.close();
    _statusController = null;
  }
}
