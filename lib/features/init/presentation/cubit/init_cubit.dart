import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/storage/secure_storage_manager.dart'; // Sesuaikan path jika berbeda
import '../../domain/usecases/check_device_readiness_usecase.dart';
import 'init_state.dart';

@injectable
class InitCubit extends Cubit<InitState> {
  final CheckDeviceReadinessUseCase checkDeviceReadinessUseCase;
  final ISecureStorageManager secureStorageManager;

  InitCubit({
    required this.checkDeviceReadinessUseCase,
    required this.secureStorageManager, // Jangan lupa tambahkan di constructor
  }) : super(InitInitial());

  /// Fungsi ini dipanggil dari UI (Splash Screen) saat initState
  Future<void> checkDeviceReadiness() async {
    emit(InitLoading());
    final result = await checkDeviceReadinessUseCase.execute();
    await result.fold(
      (failure) async {
        if (isClosed) return;
        emit(InitError(failure.message));
      },
      (isReady) async {
        final accessToken = await secureStorageManager.getAccessToken();
        final refreshToken = await secureStorageManager.getRefreshToken();

        final bool hasSession =
            (refreshToken != null && refreshToken.isNotEmpty) ||
            (accessToken != null && accessToken.isNotEmpty);
        if (isClosed) return;
        emit(InitSuccess(isLoggedIn: hasSession));
      },
    );
  }
}
