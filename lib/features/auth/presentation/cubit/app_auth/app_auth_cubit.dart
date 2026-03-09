// lib/features/auth/presentation/cubit/app_auth/app_auth_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../domain/usecases/check_auth_status_usecase.dart';
import '../../../../domain/usecases/logout_usecase.dart';
import 'app_auth_state.dart';

@injectable
class AppAuthCubit extends Cubit<AppAuthState> {
  final CheckAuthStatusUseCase _checkAuthStatus;
  final LogoutUseCase _logout;

  AppAuthCubit(this._checkAuthStatus, this._logout) : super(AppAuthInitial());

  /// Dipanggil saat Splash Screen muncul
  Future<void> checkStatus() async {
    // Memberikan jeda sedikit agar Splash Screen terlihat (Opsional)
    await Future.delayed(const Duration(seconds: 1));

    final hasValidToken = await _checkAuthStatus();
    if (hasValidToken) {
      emit(AppAuthenticated());
    } else {
      emit(AppUnauthenticated());
    }
  }

  /// Dipanggil jika token basi, atau Jukir klik tombol Logout
  Future<void> forceLogout() async {
    await _logout(); // Bersihkan brankas
    emit(AppUnauthenticated()); // Tendang ke halaman Login
  }
}
