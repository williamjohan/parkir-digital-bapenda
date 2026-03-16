// lib/features/auth/presentation/cubit/app_auth/app_auth_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/utils/app_logger.dart';
import '../../../domain/usecases/check_auth_status_usecase.dart';
import '../../../domain/usecases/logout_usecase.dart';
import '../../../../profile/domain/usecases/get_profile_usecase.dart'; // [TAMBAHAN]: Import UseCase Profile
import 'app_auth_state.dart';

@lazySingleton
class AppAuthCubit extends Cubit<AppAuthState> {
  final CheckAuthStatusUseCase _checkAuthStatus;
  final LogoutUseCase _logout;
  final GetProfileUseCase _getProfile; // [TAMBAHAN]: Injeksi UseCase Profile

  AppAuthCubit(this._checkAuthStatus, this._logout, this._getProfile)
    : super(AppAuthInitial());

  /// Dipanggil saat Splash Screen muncul ATAU setelah Login sukses
  Future<void> checkStatus({bool isFromSplash = false}) async {
    AppLogger.debug(">>> [AppAuthCubit] Mengecek status token...");

    if (isFromSplash) {
      await Future.delayed(const Duration(seconds: 1));
    }

    try {
      // 1. Cek validitas token di Brankas
      final hasValidToken = await _checkAuthStatus();
      AppLogger.debug(">>> [AppAuthCubit] Hasil cek token: $hasValidToken");

      if (hasValidToken) {
        // 2. [SILENT FETCH]: Jika token ada, tarik profil terbaru secara diam-diam!
        AppLogger.debug(
          ">>> [AppAuthCubit] Token valid, menyinkronkan profil dari server...",
        );
        final profileResult = await _getProfile();

        profileResult.fold(
          (failure) {
            // [OFFLINE TOLERANCE]: Jika server RTO atau sinyal jelek saat ambil profil,
            // Jukir TETAP DIIZINKAN MASUK ke Home menggunakan data lokal yang ada di brankas.
            AppLogger.error(
              ">>> [AppAuthCubit] Gagal sinkronisasi profil: ${failure.message}",
            );
            emit(AppAuthenticated());
          },
          (userModel) {
            // Jika sukses, profil di brankas otomatis sudah tertimpa yang baru.
            AppLogger.debug(
              ">>> [AppAuthCubit] Profil sukses disinkronkan: ${userModel.namaUser}",
            );
            emit(AppAuthenticated());
          },
        );
      } else {
        emit(AppUnauthenticated());
      }
    } catch (e) {
      AppLogger.error(">>> [AppAuthCubit] ERROR SISTEM: $e");
      emit(AppUnauthenticated());
    }
  }

  /// Dipanggil jika token basi, atau Jukir klik tombol Logout
  Future<void> forceLogout() async {
    await _logout(); // Bersihkan brankas (Token & Profil)
    emit(AppUnauthenticated()); // Tendang ke halaman Login
  }
}
