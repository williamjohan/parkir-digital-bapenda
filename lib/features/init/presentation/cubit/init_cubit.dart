// lib/features/init/presentation/cubit/init_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/check_device_readiness_usecase.dart';
import 'init_state.dart';

@injectable
class InitCubit extends Cubit<InitState> {
  final CheckDeviceReadinessUseCase checkDeviceReadinessUseCase;

  InitCubit({required this.checkDeviceReadinessUseCase}) : super(InitInitial());

  /// Fungsi ini dipanggil dari UI (Splash Screen) saat initState
  Future<void> checkDeviceReadiness() async {
    // 1. Ubah state menjadi Loading
    emit(InitLoading());

    // 2. Eksekusi UseCase
    final result = await checkDeviceReadinessUseCase.execute();

    // 3. Tangani hasil Either
    result.fold(
      (failure) => emit(InitError(failure.message)),
      (isReady) => emit(InitSuccess()),
    );
  }
}
