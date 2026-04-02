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
      // Coba ambil dari API jika forceRemote = true
      if (forceRemote) {
        AppLogger.debug('>>> [ProfileCubit] Mengambil profil dari server...');
        final result = await _getProfileUseCase();

        result.fold(
          (failure) async {
            AppLogger.error(
              '>>> [ProfileCubit] Gagal fetch dari API: ${failure.message}',
            );
            // Fallback ke local storage
            await _loadFromLocal();
          },
          (user) {
            AppLogger.debug(
              '>>> [ProfileCubit] Profil dari API berhasil dimuat',
            );
            emit(ProfileLoaded(user));
          },
        );
      } else {
        // Ambil dari local storage
        await _loadFromLocal();
      }
    } catch (e) {
      AppLogger.error('>>> [ProfileCubit] ERROR: $e');
      emit(ProfileFailure('Gagal memuat profil: ${e.toString()}'));
    }
  }

  /// Load profile dari secure storage (local)
  Future<void> _loadFromLocal() async {
    try {
      final jukirProfile = await _secureStorage.getJukirProfile();

      if (jukirProfile == null) {
        emit(ProfileFailure('Data profil tidak ditemukan'));
        return;
      }

      // Konversi Map ke UserModel
      final userModel = UserModel.fromJson(jukirProfile);
      emit(ProfileLoaded(userModel));
    } catch (e) {
      AppLogger.error('>>> [ProfileCubit] Error loading local profile: $e');
      emit(ProfileFailure('Gagal memuat profil lokal: ${e.toString()}'));
    }
  }

  /// Refresh profile dari server
  Future<void> refreshProfile() async {
    await loadProfile(forceRemote: true);
  }
}
