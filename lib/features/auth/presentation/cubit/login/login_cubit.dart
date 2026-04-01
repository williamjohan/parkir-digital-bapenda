// lib/features/auth/presentation/cubit/login/login_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/usecases/login_usecase.dart';
import '../app_auth/app_auth_cubit.dart'; // [TAMBAHAN] Import AppAuthCubit
import 'login_state.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase _loginUseCase;
  final AppAuthCubit _appAuthCubit; // [TAMBAHAN] Injeksi Sang Jenderal

  LoginCubit(this._loginUseCase, this._appAuthCubit) : super(LoginInitial());

  Future<void> loginSubmited(String username, String password) async {
    emit(LoginLoading());

    // 1. Eksekusi API Login
    final result = await _loginUseCase(username, password);

    // 2. Evaluasi Hasil
    await result.fold(
      (failure) async {
        emit(LoginFailure(failure.message));
      },
      (_) async {
        // [MASTER SYNC]: Jangan biarkan UI pindah halaman dulu!
        // Paksa AppAuthCubit untuk menarik Profil terbaru saat ini juga!
        await _appAuthCubit.checkStatus(isFromSplash: false);

        // Setelah brankas terisi dengan Profil baru, baru kita izinkan sukses!
        emit(LoginSuccess());
      },
    );
  }
}
