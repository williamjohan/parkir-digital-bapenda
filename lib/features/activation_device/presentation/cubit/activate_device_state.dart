part of 'activate_device_cubit.dart';

abstract class ActivationDeviceState {}

class ActivationDeviceInitial extends ActivationDeviceState {}

class ActivationDeviceLoading extends ActivationDeviceState {}

class ActivationDeviceSuccess extends ActivationDeviceState {}

class ActivationDeviceError extends ActivationDeviceState {
  final String message;

  ActivationDeviceError(this.message);
}
