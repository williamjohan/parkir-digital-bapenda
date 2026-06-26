import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/storage/secure_storage_manager.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../../auth/data/models/user_model.dart';

part 'profile_state.dart';

@injectable
class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase _getProfileUseCase;
  final ISecureStorageManager _secureStorage;

  ProfileCubit(this._getProfileUseCase, this._secureStorage)
    : super(ProfileInitial());

  /// Fetch user profile dari server atau local storage
  Future<void> loadProfile({bool forceRemote = false}) async {
    emit(ProfileLoading());

    try {
      if (forceRemote) {
        AppLogger.debug(
          '>>> [ProfileCubit] Mengambil profil dari server (Force Remote)...',
        );
        await _fetchFromApi();
      } else {
        final jukirProfile = await _secureStorage.getJukirProfile();

        if (jukirProfile != null) {
          AppLogger.debug('>>> [ProfileCubit] Profil ditemukan di lokal!');
          final userModel = UserModel.fromJson(jukirProfile);
          emit(ProfileLoaded(userModel));
        } else {
          AppLogger.debug(
            '>>> [ProfileCubit] Lokal kosong (Cache Miss), otomatis mengambil dari API...',
          );
          await _fetchFromApi();
        }
      }
    } catch (e) {
      AppLogger.error('>>> [ProfileCubit] ERROR: $e');
      emit(ProfileFailure('Gagal memuat profil: ${e.toString()}'));
    }
  }

  /// Eksekusi pemanggilan API (Penyimpanan lokal sudah di-handle oleh Repository)
  Future<void> _fetchFromApi() async {
    final result = await _getProfileUseCase();

    result.fold(
      (failure) {
        AppLogger.error(
          '>>> [ProfileCubit] Gagal fetch dari API: ${failure.message}',
        );
        emit(ProfileFailure(failure.message));
      },
      (user) {
        AppLogger.debug('>>> [ProfileCubit] Profil dari API berhasil dimuat');
        emit(ProfileLoaded(user));
      },
    );
  }

  /// Refresh profile dari server
  Future<void> refreshProfile() async {
    await loadProfile(forceRemote: true);
  }
}
