import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:signalr_netcore/signalr_client.dart';
import '../../../../core/utils/app_logger.dart';

@lazySingleton
class QrisSignalRDatasource {
  HubConnection? _connection;

  // StreamController dibuat nullable agar bisa di-reset per sesi
  StreamController<String>? _statusController;

  // Simpan kodeQris aktif untuk keperluan re-join saat reconnect
  String? _activeKodeQris;

  /// Expose stream — dibuat fresh setiap sesi connectAndJoin
  Stream<String> get qrisStatusStream {
    _statusController ??= StreamController<String>.broadcast();
    return _statusController!.stream;
  }

  /// Buka koneksi dan join group kodeQris
  Future<void> connectAndJoin(String kodeQris) async {
    try {
      // Matikan koneksi lama jika masih ada
      await disconnect();

      // Reset stream controller untuk sesi baru
      // await _statusController?.close();
      // _statusController = StreamController<String>.broadcast();

      _activeKodeQris = kodeQris;

      _connection = HubConnectionBuilder()
          .withUrl("https://apibapenda.surabaya.go.id:8282/qrisHub")
          .withAutomaticReconnect()
          .build();

      // Daftarkan listeners SEBELUM start — urutan ini penting
      _registerListeners();

      await _connection!.start();
      AppLogger.debug('✅ [SignalR] Connected! State: ${_connection!.state}');

      // Join group di BE
      await _joinGroup(kodeQris);
    } catch (e) {
      AppLogger.error('🚨 [SignalR] Gagal connect: $e');
      _statusController?.add("ERROR");
    }
  }

  /// Join group — dipisah agar bisa dipanggil ulang saat reconnect
  Future<void> _joinGroup(String kodeQris) async {
    try {
      await _connection!.invoke("QrisStatus", args: [kodeQris]);
      AppLogger.debug('📡 [SignalR] Joined group: $kodeQris');
    } catch (e) {
      AppLogger.error('❌ [SignalR] Gagal join group: $e');
      _statusController?.add("ERROR");
    }
  }

  /// Daftarkan semua event listeners + reconnect handler
  void _registerListeners() {
    _connection?.on("QRIS_LUNAS", (arguments) {
      AppLogger.debug('💰 [SignalR] QRIS_LUNAS — args: $arguments');
      _statusController?.add("LUNAS");
    });

    _connection?.on("QRIS_PENDING", (arguments) {
      AppLogger.debug('⏳ [SignalR] QRIS_PENDING — args: $arguments');
      _statusController?.add("PENDING");
    });

    _connection?.on("QRIS_TIMEOUT", (arguments) {
      AppLogger.debug('⏰ [SignalR] QRIS_TIMEOUT — args: $arguments');
      _statusController?.add("TIMEOUT");
    });

    _connection?.on("QRIS_ERROR", (arguments) {
      AppLogger.debug('❌ [SignalR] QRIS_ERROR — args: $arguments');

      // 🚀 [FILTER]: Cek apakah ini error palsu
      try {
        if (arguments != null && arguments.isNotEmpty) {
          final payload = arguments[0] as Map<dynamic, dynamic>?;
          if (payload != null && payload['status'] == 'PENDING') {
            AppLogger.debug(
              '🛡️ False Alarm ditahan! Status sebenarnya masih PENDING.',
            );
            return; // Berhenti di sini, jangan kirim "ERROR" ke stream
          }
        }
      } catch (e) {
        AppLogger.error('Gagal parsing error payload: $e');
      }

      _statusController?.add("ERROR");
    });

    // FIX KRITIS: Re-join group saat koneksi reconnect otomatis
    // Tanpa ini, setelah reconnect device tidak ada di group kodeQris lagi
    _connection?.onreconnected(({connectionId}) async {
      AppLogger.debug('🔄 [SignalR] Reconnected — connectionId: $connectionId');
      if (_activeKodeQris != null) {
        await _joinGroup(_activeKodeQris!);
      }
    });

    _connection?.onclose(({error}) {
      AppLogger.debug('🛑 [SignalR] Connection closed — error: $error');
    });
  }

  /// Tutup koneksi dengan urutan yang benar
  Future<void> disconnect() async {
    if (_connection != null &&
        _connection!.state == HubConnectionState.Connected) {
      // FIX: .off() dulu sebelum .stop()
      _connection!.off("QRIS_LUNAS");
      _connection!.off("QRIS_PENDING");
      _connection!.off("QRIS_TIMEOUT");
      _connection!.off("QRIS_ERROR");
      await _connection!.stop();
      AppLogger.debug('🛑 [SignalR] Disconnected');
    }
    _connection = null;
    _activeKodeQris = null;
  }

  /// Dispose total — dipanggil saat datasource di-destroy
  Future<void> dispose() async {
    await disconnect();
    await _statusController?.close();
    _statusController = null;
  }
}
