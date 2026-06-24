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
      // 🚀 1. Ambil versi aplikasi lokal yang terinstal di HP saat ini
      final packageInfo = await PackageInfo.fromPlatform();
      // buildNumber biasanya berupa String "1", "2", dst. Kita ubah ke integer.
      final int localVersionCode = int.tryParse(packageInfo.buildNumber) ?? 0;

      // 🚀 2. Ambil data JSON terbaru dari Server/Drive (melalui UseCase)
      final result = await _checkUpdateUseCase.execute();

      print(">>> AUDIT CUBIT: Hasil dari UseCase adalah: $result");

      if (isClosed) return;

      result.fold((failure) => emit(CheckUpdateError(failure.message)), (
        updateEntity,
      ) {
        // Jaring pengaman jika JSON gagal di-parsing
        if (updateEntity == null) {
          emit(CheckUpdateError("Data pembaruan tidak ditemukan."));
          return;
        }

        // 🚀 3. Eksekusi Perbandingan (Auditor Logic)
        if (localVersionCode < updateEntity.buildNumber) {
          // Jika versi lokal lebih kecil, paksa update!
          emit(CheckUpdateAvailable(updateEntity));
        } else {
          // Jika versi lokal sama (atau lebih besar), aplikasi aman! Tampilkan Changelog.
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
