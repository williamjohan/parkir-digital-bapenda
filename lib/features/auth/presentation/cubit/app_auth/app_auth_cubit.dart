// lib/features/auth/presentation/cubit/app_auth/app_auth_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/utils/app_logger.dart';
import '../../../domain/usecases/check_auth_status_usecase.dart';
import '../../../domain/usecases/logout_usecase.dart';
import 'app_auth_state.dart';

@lazySingleton
class AppAuthCubit extends Cubit<AppAuthState> {
  final CheckAuthStatusUseCase _checkAuthStatus;
  final LogoutUseCase _logout;

  AppAuthCubit(this._checkAuthStatus, this._logout) : super(AppAuthInitial());

  /// Dipanggil saat Splash Screen muncul
  Future<void> checkStatus({bool isFromSplash = false}) async {
    AppLogger.debug(">>> [AppAuthCubit] Mengecek status token...");

    // Bungkus delay dengan kondisi
    if (isFromSplash) {
      await Future.delayed(const Duration(seconds: 1));
    }

    try {
      final hasValidToken = await _checkAuthStatus();
      AppLogger.debug(">>> [AppAuthCubit] Hasil cek token: $hasValidToken");

      if (hasValidToken) {
        emit(AppAuthenticated());
      } else {
        emit(AppUnauthenticated());
      }
    } catch (e) {
      AppLogger.error(">>> [AppAuthCubit] ERROR MEMBACA BRANKAS: $e");
      // Fallback agar tidak stuck di splash screen
      emit(AppUnauthenticated());
    }
  }

  /// Dipanggil jika token basi, atau Jukir klik tombol Logout
  Future<void> forceLogout() async {
    await _logout(); // Bersihkan brankas
    emit(AppUnauthenticated()); // Tendang ke halaman Login
  }
}
