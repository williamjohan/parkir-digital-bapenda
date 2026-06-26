import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:signalr_netcore/signalr_client.dart';
import '../../../../core/utils/app_logger.dart';

@lazySingleton
class QrisSignalRDatasource {
  HubConnection? _connection;

  StreamController<String>? _statusController;
  String? _activeKodeQris;

  Stream<String> get qrisStatusStream {
    _statusController ??= StreamController<String>.broadcast();
    return _statusController!.stream;
  }

  /// Buka koneksi dan join group kodeQris
  Future<void> connectAndJoin(String kodeQris) async {
    try {
      await disconnect();

      _activeKodeQris = kodeQris;

      _connection = HubConnectionBuilder()
          .withUrl("https://apibapenda.surabaya.go.id:8282/qrisHub")
          .withAutomaticReconnect()
          .build();

      _registerListeners();

      await _connection!.start();
      AppLogger.debug('✅ [SignalR] Connected! State: ${_connection!.state}');

      await _joinGroup(kodeQris);
    } catch (e) {
      AppLogger.error('🚨 [SignalR] Gagal connect: $e');
      _statusController?.add("ERROR");
    }
  }

  Future<void> _joinGroup(String kodeQris) async {
    try {
      if (_connection?.state == HubConnectionState.Connected) {
        await _connection!.invoke("QrisStatus", args: [kodeQris]);
        AppLogger.debug('📡 [SignalR] Joined group: $kodeQris');
      }
    } catch (e) {
      AppLogger.error('❌ [SignalR] Gagal invoke QrisStatus: $e');
    }
  }

  /// Event Listeners
  void _registerListeners() {
    _connection?.on("QRIS_LUNAS", (arguments) {
      AppLogger.debug('💰 [SignalR] QRIS_LUNAS — args: $arguments');
      _statusController?.add("LUNAS");
    });

    _connection?.on("QRIS_PENDING", (arguments) {
      AppLogger.debug('⏳ [SignalR] QRIS_PENDING — args: $arguments');
    });

    _connection?.on("QRIS_TIMEOUT", (arguments) {
      AppLogger.debug('⏰ [SignalR] QRIS_TIMEOUT — args: $arguments');
      _statusController?.add("TIMEOUT");
    });
    _connection?.on("QRIS_ERROR", (arguments) {
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
      _statusController?.add("ERROR");
    });

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

  /// Close
  Future<void> disconnect() async {
    if (_connection != null &&
        _connection!.state == HubConnectionState.Connected) {
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

  /// Dispose
  Future<void> dispose() async {
    await disconnect();
    await _statusController?.close();
    _statusController = null;
  }
}
