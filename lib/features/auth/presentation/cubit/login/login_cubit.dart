import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/di/injection.dart';
import '../../../../../core/storage/i_secure_storage_manager.dart';
import '../../../../../core/utils/app_logger.dart';
import '../../../domain/usecases/get_kantorku_sso_url_usecase.dart';
import '../../../domain/usecases/get_sso_token_stream_usecase.dart';
import '../../../domain/usecases/login_usecase.dart';
import '../../../domain/usecases/login_with_sso_usecase.dart';
import '../app_auth/app_auth_cubit.dart';
import 'login_state.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase _loginUseCase;
  final AppAuthCubit _appAuthCubit;
  final GetKantorkuSsoUrlUseCase _getKantorkuSsoUrlUseCase;
  final GetSsoTokenStreamUseCase _getSsoTokenStreamUseCase;
  final LoginWithSsoUseCase _loginWithSsoUseCase;

  StreamSubscription<String>? _ssoSubscription;

  LoginCubit(
    this._loginUseCase,
    this._appAuthCubit,
    this._getKantorkuSsoUrlUseCase,
    this._getSsoTokenStreamUseCase,
    this._loginWithSsoUseCase,
  ) : super(LoginInitial()) {
    _initSsoListener();
  }

  void _initSsoListener() {
    _ssoSubscription = _getSsoTokenStreamUseCase().listen((sessionId) {
      _processSsoCallback(sessionId);
    });
  }

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

  Future<void> initiateKantorkuSSO() async {
    emit(LoginLoading());

    final result = await _getKantorkuSsoUrlUseCase();

    result.fold(
      (failure) => emit(LoginFailure(failure.message)),
      (url) => emit(LoginSsoUrlReady(url)),
    );
  }

  Future<void> _processSsoCallback(String sessionId) async {
    emit(LoginLoading());
    AppLogger.debug(
      '✅ Cubit menerima Session ID SSO via Clean Architecture: $sessionId',
    );

    final result = await _loginWithSsoUseCase(sessionId);

    await result.fold(
      (failure) async {
        emit(LoginFailure(failure.message));
      },
      (_) async {
        await _appAuthCubit.checkStatus(isFromSplash: false);

        emit(LoginSuccess());
      },
    );
  }

  @override
  Future<void> close() {
    _ssoSubscription?.cancel();
    return super.close();
  }
}
