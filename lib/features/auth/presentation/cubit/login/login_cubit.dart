import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/di/injection.dart';
import '../../../../../core/storage/i_secure_storage_manager.dart';
import '../../../domain/usecases/login_usecase.dart';
import '../app_auth/app_auth_cubit.dart'; // [TAMBAHAN] Import AppAuthCubit
import 'login_state.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase _loginUseCase;
  final AppAuthCubit _appAuthCubit;

  LoginCubit(this._loginUseCase, this._appAuthCubit) : super(LoginInitial());

  Future<void> loginSubmited(
    String username,
    String password,
    bool rememberMe,
  ) async {
    emit(LoginLoading());
    final result = await _loginUseCase(username, password);
    await result.fold(
      (failure) async {
        emit(LoginFailure(failure.message));
      },
      (_) async {
        if (rememberMe) {
          await locator<ISecureStorageManager>().saveCredentials(
            username,
            password,
          );
        }
        await _appAuthCubit.checkStatus(isFromSplash: false);
        emit(LoginSuccess());
      },
    );
  }
}
