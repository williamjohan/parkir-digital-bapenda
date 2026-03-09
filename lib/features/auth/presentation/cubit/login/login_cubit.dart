// lib/features/auth/presentation/cubit/login/login_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/usecases/login_usecase.dart';
import 'login_state.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase _loginUseCase;

  LoginCubit(this._loginUseCase) : super(LoginInitial());

  Future<void> loginSubmited(String username, String password) async {
    emit(LoginLoading());

    // Panggil Use Case (Jembatan kita ke Repository)
    final result = await _loginUseCase(username, password);

    // Fold dari package dartz: Kiri (Failure), Kanan (Success/Unit)
    result.fold(
      (failure) => emit(LoginFailure(failure.message)),
      (_) => emit(LoginSuccess()),
    );
  }
}
