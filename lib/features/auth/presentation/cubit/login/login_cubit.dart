import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/utils/app_logger.dart';
import '../../../domain/usecases/login_usecase.dart';
import 'login_state.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase _loginUsecase;

  StreamSubscription<String>? _ssoSubscription;

  LoginCubit(this._loginUsecase) : super(LoginInitial()) {
    _initSsoListener();
  }

  void _initSsoListener() {
    _ssoSubscription = _loginUsecase.ssoTokenStream.listen((sessionId) {
      _processSsoCallback(sessionId);
    });
  }

  Future<void> loginSubmited(
    String username,
    String password,
    bool rememberMe,
  ) async {
    emit(LoginLoading());
    final result = await _loginUsecase.loginReguler(username, password);

    if (isClosed) return;

    await result.fold(
      (failure) async {
        emit(LoginFailure(failure.message));
      },
      (_) async {
        if (rememberMe) {
          // 🚀 BERKOMUNIKASI LEWAT FACADE
          await _loginUsecase.saveCredentials(username, password);
        }

        if (isClosed) return;
        emit(LoginSuccess());
      },
    );
  }

  Future<void> initiateKantorkuSSO() async {
    emit(LoginLoading());
    final result = await _loginUsecase.getKantorkuSsoUrl();

    if (isClosed) return;

    result.fold(
      (failure) => emit(LoginFailure(failure.message)),
      (url) => emit(LoginSsoUrlReady(url)),
    );
  }

  Future<void> _processSsoCallback(String sessionId) async {
    emit(LoginLoading());
    AppLogger.debug('✅ Session ID SSO: $sessionId');

    final result = await _loginUsecase.loginWithSso(sessionId);

    if (isClosed) return;

    await result.fold(
      (failure) async {
        emit(LoginFailure(failure.message));
      },
      (_) async {
        if (isClosed) return;
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
