import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/usecase/activate_device_usecase.dart';
import 'package:flutter_udid/flutter_udid.dart';

part 'activate_device_state.dart';

@injectable
class ActivationDeviceCubit extends Cubit<ActivationDeviceState> {
  final ActivateDeviceUseCase activateDeviceUseCase;

  ActivationDeviceCubit(this.activateDeviceUseCase)
    : super(ActivationDeviceInitial());

  Future<void> activate({required String nop}) async {
    try {
      emit(ActivationDeviceLoading());

      final deviceId = await FlutterUdid.udid;

      final result = await activateDeviceUseCase.execute(
        nop: nop,
        deviceId: "519", // testing
        // deviceId = deviceId
      );

      result.fold(
        (failure) {
          AppLogger.error("Activation Failed: ${failure.message}");
          emit(ActivationDeviceError(failure.message));
        },
        (isSuccess) {
          emit(ActivationDeviceSuccess());
        },
      );
    } catch (e) {
      AppLogger.error("Unexpected Error: $e");
      emit(ActivationDeviceError("Terjadi kesalahan, coba lagi"));
    }
  }
}
