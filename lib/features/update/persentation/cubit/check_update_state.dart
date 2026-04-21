import '../../entities/update_entity.dart';

abstract class CheckUpdateState {}

class CheckUpdateInitial extends CheckUpdateState {}

class CheckUpdateLoading extends CheckUpdateState {}

class CheckUpdateAvailable extends CheckUpdateState {
  final UpdateEntity update;
  CheckUpdateAvailable(this.update);
}

class CheckUpdateUpToDate extends CheckUpdateState {}

class CheckUpdateError extends CheckUpdateState {
  final String message;
  CheckUpdateError(this.message);
}
