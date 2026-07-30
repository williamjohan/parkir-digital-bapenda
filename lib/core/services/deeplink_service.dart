import 'dart:async';
import 'package:app_links/app_links.dart';
import '../utils/app_logger.dart';

class DeeplinkService {
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;

  // Stream ini akan memancarkan Token/Code ke siapa saja yang mendengarkan (seperti LoginCubit)
  final _ssoTokenController = StreamController<String>.broadcast();
  Stream<String> get ssoTokenStream => _ssoTokenController.stream;

  /// Panggil metode ini saat aplikasi pertama kali dijalankan (misal di main.dart)
  void init() {
    AppLogger.debug('Menyalakan Radar Deeplink...');

    // Mendengarkan tautan yang masuk saat aplikasi berjalan (Foreground / Background)
    _linkSubscription = _appLinks.uriLinkStream.listen(
      (Uri uri) {
        _handleIncomingUri(uri);
      },
      onError: (err) {
        AppLogger.error('Gagal membaca Deeplink', err, null);
      },
    );
  }

  void _handleIncomingUri(Uri uri) {
    AppLogger.debug('🔗 Deeplink tertangkap: $uri');

    // Validasi skema (tspark://auth)
    if (uri.scheme == 'tspark' && uri.host == 'auth') {
      // 🚀 ADJUSTMENT: Menangkap parameter 'session' sesuai kesepakatan BE
      final sessionId = uri.queryParameters['session'];

      if (sessionId != null && sessionId.isNotEmpty) {
        AppLogger.debug('✅ Session ID SSO berhasil diekstrak: $sessionId');
        // Pancarkan sessionId ke LoginCubit
        _ssoTokenController.add(sessionId);
      } else {
        AppLogger.debug('⚠️ Deeplink valid, tetapi tidak membawa Session ID.');
      }
    }
  }

  void dispose() {
    _linkSubscription?.cancel();
    _ssoTokenController.close();
  }
}
