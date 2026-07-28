import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

/// Sukses login tidak perlu bawa data, karena AppAuthCubit yang akan ambil alih
class LoginSuccess extends LoginState {}

class LoginFailure extends LoginState {
  final String message;
  const LoginFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class LoginSsoUrlReady extends LoginState {
  final String url;
  const LoginSsoUrlReady(this.url);

  @override
  List<Object> get props => [url];
}
