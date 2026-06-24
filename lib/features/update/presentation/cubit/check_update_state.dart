import 'package:equatable/equatable.dart';
import '../../domain/entities/update_entity.dart';

abstract class CheckUpdateState extends Equatable {
  const CheckUpdateState();

  @override
  List<Object?> get props => [];
}

class CheckUpdateInitial extends CheckUpdateState {}

class CheckUpdateLoading extends CheckUpdateState {}

class CheckUpdateAvailable extends CheckUpdateState {
  final UpdateEntity update;

  const CheckUpdateAvailable(this.update);

  @override
  List<Object?> get props => [update];
}

class CheckUpdateUpToDate extends CheckUpdateState {
  final String versionName;
  final String changelog;

  const CheckUpdateUpToDate(this.versionName, this.changelog);

  @override
  List<Object?> get props => [versionName, changelog];
}

class CheckUpdateError extends CheckUpdateState {
  final String message;

  const CheckUpdateError(this.message);

  @override
  List<Object?> get props => [message];
}
