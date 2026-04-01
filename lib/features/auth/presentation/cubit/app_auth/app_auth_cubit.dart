// lib/features/auth/presentation/cubit/app_auth/app_auth_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/storage/secure_storage_manager.dart';
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
          (failure) async {
            // Tambahkan async
            AppLogger.error(
              ">>> [AppAuthCubit] Gagal sinkronisasi profil: ${failure.message}",
            );

            final locator = GetIt.instance; // Pastikan Anda import get_it
            final localProfile = await locator<ISecureStorageManager>()
                .getJukirProfile();

            if (localProfile != null) {
              // Boleh masuk pakai Offline Tolerance (Data Kemarin)
              emit(AppAuthenticated());
            } else {
              // Dilarang keras masuk! Brankas kosong dan API gagal.
              // Biasanya terjadi pada Fresh Login yang sinyalnya jelek.
              emit(AppUnauthenticated());
            }
          },
          (userModel) {
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
