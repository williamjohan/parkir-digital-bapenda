// lib/features/init/presentation/cubit/init_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/storage/secure_storage_manager.dart'; // Sesuaikan path jika berbeda
import '../../domain/usecases/check_device_readiness_usecase.dart';
import 'init_state.dart';

@injectable
class InitCubit extends Cubit<InitState> {
  final CheckDeviceReadinessUseCase checkDeviceReadinessUseCase;

  // [TAMBAHAN]: Injeksi Brankas Penyimpanan Rahasia
  final ISecureStorageManager secureStorageManager;

  InitCubit({
    required this.checkDeviceReadinessUseCase,
    required this.secureStorageManager, // Jangan lupa tambahkan di constructor
  }) : super(InitInitial());

  /// Fungsi ini dipanggil dari UI (Splash Screen) saat initState
  Future<void> checkDeviceReadiness() async {
    // 1. Ubah state menjadi Loading
    emit(InitLoading());

    // 2. Eksekusi UseCase (Cek Kamera & Sistem)
    final result = await checkDeviceReadinessUseCase.execute();

    // 3. Tangani hasil Either
    result.fold(
      (failure) {
        if (!isClosed) {
          emit(InitError(failure.message));
        }
      },
      // [PERBAIKAN]: Ubah menjadi async karena kita akan membuka brankas
      (isReady) async {
        if (!isClosed) {
          // 4. CEK TIKET MASUK (The Gold Standard)
          // Ambil kedua token dari Brankas
          final accessToken = await secureStorageManager.getAccessToken();
          final refreshToken = await secureStorageManager.getRefreshToken();

          // Sesi dianggap VALID jika Refresh Token ada.
          // (Atau Access Token ada, sebagai pertahanan ganda jika Refresh Token sedang kosong)
          final bool hasSession =
              (refreshToken != null && refreshToken.isNotEmpty) ||
              (accessToken != null && accessToken.isNotEmpty);

          // 5. Emit Success beserta status tiketnya!
          emit(InitSuccess(isLoggedIn: hasSession));
        }
      },
    );
  }
}
