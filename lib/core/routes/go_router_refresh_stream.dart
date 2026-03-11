// lib/core/routes/go_router_refresh_stream.dart

import 'dart:async';
import 'package:flutter/foundation.dart';

/// Jembatan pengubah Stream (dari Cubit/Bloc) menjadi Listenable (untuk GoRouter)
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.listen((dynamic _) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
