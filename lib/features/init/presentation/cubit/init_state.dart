// lib/features/init/presentation/cubit/init_state.dart

import 'package:equatable/equatable.dart';

abstract class InitState extends Equatable {
  const InitState();

  @override
  List<Object> get props => [];
}

class InitInitial extends InitState {}

class InitLoading extends InitState {}

class InitSuccess extends InitState {}

class InitError extends InitState {
  final String message;

  const InitError(this.message);

  @override
  List<Object> get props => [message];
}
