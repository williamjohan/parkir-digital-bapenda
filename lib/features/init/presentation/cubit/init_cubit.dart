import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/storage/secure_storage_manager.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/usecases/check_device_readiness_usecase.dart';
import 'init_state.dart';
import 'package:flutter_udid/flutter_udid.dart';

@injectable
class InitCubit extends Cubit<InitState> {
  final CheckDeviceReadinessUseCase checkDeviceReadinessUseCase;
  final ISecureStorageManager secureStorageManager;

  InitCubit({
    required this.checkDeviceReadinessUseCase,
    required this.secureStorageManager,
  }) : super(InitInitial());

  Future<void> checkDeviceActivation() async {
    AppLogger.debug("════════════════ INIT FLOW START ════════════════");
    AppLogger.debug("[InitCubit] Start checkDeviceActivation");

    emit(InitLoading());

    try {
      /// 🔥 1. CHECK DEVICE READY
      AppLogger.debug("[InitCubit] Checking device readiness...");
      final readinessResult = await checkDeviceReadinessUseCase.execute();

      await readinessResult.fold(
        (failure) async {
          AppLogger.debug("[InitCubit] ❌ Device NOT ready");
          AppLogger.debug("[InitCubit] Failure: ${failure.message}");
          emit(InitError(failure.message));
        },
        (isReady) async {
          AppLogger.debug("[InitCubit] ✅ Device ready: $isReady");

          final deviceId = await FlutterUdid.udid;

          /// 🔥 2. GET PROFILE
          AppLogger.debug("[InitCubit] Fetching jukir profile from storage...");
          final profile = await secureStorageManager.getJukirProfile();

          AppLogger.debug("[InitCubit] Profile result: $profile");

          /// ❗ BELUM ADA PROFILE
          if (profile == null) {
            AppLogger.debug("[InitCubit] ❌ Profile NULL → Need Activation");
            emit(InitNeedActivation());
            return;
          }

          final nop = profile['nop'] ?? '';
          AppLogger.debug("[InitCubit] NOP: $nop");

          /// ❗ NOP KOSONG
          if (nop.isEmpty) {
            AppLogger.debug("[InitCubit] ❌ NOP kosong → Need Activation");
            emit(InitNeedActivation());
            return;
          }

          /// 🔥 3. CHECK TOKEN
          AppLogger.debug("[InitCubit] Checking session tokens...");

          final accessToken = await secureStorageManager.getAccessToken();
          final refreshToken = await secureStorageManager.getRefreshToken();

          AppLogger.debug("[InitCubit] Access Token: $accessToken");
          AppLogger.debug("[InitCubit] Refresh Token: $refreshToken");

          final hasSession =
              (refreshToken != null && refreshToken.isNotEmpty) ||
              (accessToken != null && accessToken.isNotEmpty);

          AppLogger.debug("[InitCubit] Session status: $hasSession");

          if (hasSession) {
            AppLogger.debug("[InitCubit] ✅ User LOGGED IN → Go to HOME");
          } else {
            AppLogger.debug("[InitCubit] ⚠️ No session → Go to LOGIN");
          }

          emit(InitSuccess(isLoggedIn: hasSession));
        },
      );
    } catch (e, stackTrace) {
      AppLogger.debug("[InitCubit] ❌ ERROR OCCURRED");
      AppLogger.debug("[InitCubit] Error: $e");
      AppLogger.debug("[InitCubit] StackTrace: $stackTrace");

      emit(InitError(e.toString()));
    }

    AppLogger.debug("════════════════ INIT FLOW END ════════════════");
  }
}
