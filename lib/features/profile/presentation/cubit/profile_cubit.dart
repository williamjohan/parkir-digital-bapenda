import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:parkir_digital_bapenda/features/auth/domain/entities/user_entity.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/usecases/profile_usecase.dart'; // Import UseCase baru kita

part 'profile_state.dart';

@injectable
class ProfileCubit extends Cubit<ProfileState> {
  final ProfileUseCase _profileUseCase;

  ProfileCubit(this._profileUseCase) : super(ProfileInitial());

  Future<void> loadProfile({bool forceRefresh = false}) async {
    // 1. Cegah UI berkedip (flicker) saat pull-to-refresh
    final currentState = state;
    if (currentState is! ProfileLoaded &&
        currentState is! ProfileRefreshError) {
      emit(ProfileLoading());
    }

    final profileResult = await _profileUseCase.getProfileInfo(
      forceRefresh: forceRefresh,
    );
    final photoResult = await _profileUseCase.getProfilePicturePath(
      forceRefresh: forceRefresh,
    );

    profileResult.fold(
      (failure) {
        AppLogger.error(
          '>>> [ProfileCubit] Gagal memuat profil: ${failure.message}',
        );

        // --- LOGIKA PENYELAMATAN DATA (Jika gagal saat refresh) ---
        if (currentState is ProfileLoaded) {
          emit(
            ProfileRefreshError(
              currentState.user,
              failure.message,
              oldPhotoPath: currentState.photoPath,
            ),
          );
        } else if (currentState is ProfileRefreshError) {
          emit(
            ProfileRefreshError(
              currentState.oldUser,
              failure.message,
              oldPhotoPath: currentState.oldPhotoPath,
            ),
          );
        } else {
          emit(ProfileFailure(failure.message));
        }
      },
      (userEntity) {
        AppLogger.debug('>>> [ProfileCubit] Profil berhasil dimuat!');

        // 4. Olah hasil foto (jika gagal, biarkan null)
        final photoPath = photoResult.fold(
          (failure) => null,
          (path) => path.isNotEmpty ? path : null,
        );

        emit(ProfileLoaded(userEntity, photoPath: photoPath));
      },
    );
  }

  Future<void> refreshProfile() async {
    await loadProfile(forceRefresh: true);
  }
}
