import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart'; // 🚀 WAJIB IMPORT INI
import '../../domain/usecases/check_update_usecase.dart';
import 'check_update_state.dart';

@injectable
class CheckUpdateCubit extends Cubit<CheckUpdateState> {
  final CheckUpdateUseCase _checkUpdateUseCase;

  CheckUpdateCubit(this._checkUpdateUseCase) : super(CheckUpdateInitial());

  Future<void> checkNow() async {
    emit(CheckUpdateLoading());

    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final int localVersionCode = int.tryParse(packageInfo.buildNumber) ?? 0;
      final result = await _checkUpdateUseCase.execute();

      if (isClosed) return;

      result.fold((failure) => emit(CheckUpdateError(failure.message)), (
        updateEntity,
      ) {
        if (updateEntity == null) {
          emit(CheckUpdateError("Data pembaruan tidak ditemukan."));
          return;
        }
        if (localVersionCode < updateEntity.buildNumber) {
          emit(CheckUpdateAvailable(updateEntity));
        } else {
          emit(
            CheckUpdateUpToDate(
              updateEntity.versionName,
              updateEntity.changelog,
            ),
          );
        }
      });
    } catch (e) {
      if (!isClosed) {
        emit(CheckUpdateError("Terjadi kesalahan sistem saat mengecek versi."));
      }
    }
  }
}
