import 'package:dio/dio.dart';
import 'package:parkir_digital_bapenda/core/network/resilent_dns_resolver.dart';
import '../utils/app_logger.dart';

/// Interceptor observability murni: mencatat status resolusi DNS
/// sebelum request dikirim. Tidak mengubah request — hanya untuk telemetry,
/// supaya tim tahu device/jaringan mana yang sering gagal DNS.
class DnsDiagnosticInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final host = options.uri.host;
    final ip = await ResilientDnsResolver.resolveIp(host);
    if (ip == null) {
      AppLogger.error(
        '>>> [DNS DIAGNOSTIC] Gagal resolve host "$host" sebelum request ke ${options.path}. '
        'Request tetap dilanjutkan, actual connect akan pakai fallback IP di adapter.',
      );
    }
    handler.next(options);
  }
}
