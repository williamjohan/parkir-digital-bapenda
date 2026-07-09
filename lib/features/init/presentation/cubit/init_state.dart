import 'package:equatable/equatable.dart';

abstract class InitState extends Equatable {
  const InitState();

  @override
  List<Object> get props => [];
}

class InitInitial extends InitState {}

class InitLoading extends InitState {}

class InitSuccess extends InitState {
  final bool isLoggedIn;

  const InitSuccess({required this.isLoggedIn});

  @override
  List<Object> get props => [isLoggedIn];
}

class InitError extends InitState {
  final String message;

  const InitError(this.message);

  @override
  List<Object> get props => [message];
}
