import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:signalr_netcore/signalr_client.dart';
import '../../../../core/utils/app_logger.dart';

@lazySingleton
class QrisSignalRDatasource {
  HubConnection? _connection;

  // 🚀 [THE STREAM ENGINE]: Ini adalah corong tempat kita memancarkan status QRIS
  // Kita pakai .broadcast() agar bisa didengarkan oleh UI berulang kali
  final StreamController<String> _statusController =
      StreamController<String>.broadcast();

  // Expose stream-nya ke Repository / Cubit
  Stream<String> get qrisStatusStream => _statusController.stream;

  /// 🔌 Buka Koneksi dan Langsung Berlangganan (Join)
  Future<void> connectAndJoin(String kodeQris) async {
    try {
      // 1. Matikan koneksi lama jika masih ada (Mencegah Zombie Connection)
      await disconnect();

      // 2. Bangun Koneksi Baru
      _connection = HubConnectionBuilder()
          .withUrl("https://apibapenda.surabaya.go.id:8282/qrisHub")
          .withAutomaticReconnect()
          .build();

      // 3. Daftarkan Telinga (Event Listeners) SEBELUM start connection
      _registerListeners();

      // 4. Mulai Koneksi
      await _connection!.start();
      AppLogger.debug('✅ [SignalR] Connected to QRIS Hub!');

      // 5. Masuk ke Ruang Tunggu Khusus QRIS ini
      await _connection!.invoke("QrisStatus", args: [kodeQris]);
      AppLogger.debug('📡 [SignalR] Joined QRIS Room: $kodeQris');
    } catch (e) {
      AppLogger.error('🚨 [SignalR] Gagal connect: $e');
      _statusController.add("ERROR");
    }
  }

  /// 🎧 Daftarkan semua event yang ditembak server Bapenda
  void _registerListeners() {
    _connection?.on("QRIS_LUNAS", (arguments) {
      AppLogger.debug('💰 [SignalR] EVENT: QRIS_LUNAS Diterima!');
      _statusController.add("LUNAS");
    });

    _connection?.on("QRIS_PENDING", (arguments) {
      AppLogger.debug('⏳ [SignalR] EVENT: QRIS_PENDING');
      _statusController.add("PENDING");
    });

    _connection?.on("QRIS_TIMEOUT", (arguments) {
      AppLogger.debug('⏰ [SignalR] EVENT: QRIS_TIMEOUT');
      _statusController.add("TIMEOUT");
    });

    _connection?.on("QRIS_ERROR", (arguments) {
      AppLogger.debug('❌ [SignalR] EVENT: QRIS_ERROR');
      _statusController.add("ERROR");
    });
  }

  /// 🛑 Tutup koneksi saat Jukir keluar dari halaman QRIS
  Future<void> disconnect() async {
    if (_connection != null &&
        _connection!.state == HubConnectionState.Connected) {
      await _connection!.stop();
      // Hapus semua listener saat disconnect
      _connection!.off("QRIS_LUNAS");
      _connection!.off("QRIS_PENDING");
      _connection!.off("QRIS_TIMEOUT");
      _connection!.off("QRIS_ERROR");
      _connection = null; // ← Tambah ini
      AppLogger.debug('🛑 [SignalR] Disconnected');
    }
  }
}
