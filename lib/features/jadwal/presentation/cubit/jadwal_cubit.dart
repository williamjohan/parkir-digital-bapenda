import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/usecases/jadwal_usecase.dart';
import 'jadwal_state.dart';

@injectable
class JadwalCubit extends Cubit<JadwalState> {
  final JadwalUseCase _getJadwalUseCase;

  JadwalCubit(this._getJadwalUseCase) : super(const JadwalState());

  Future<void> fetchJadwal({bool forceRefresh = false}) async {
    emit(state.copyWith(status: JadwalStatus.loading));

    AppLogger.info('>>> [JadwalCubit] Mengeksekusi permintaan data jadwal...');

    final result = await _getJadwalUseCase.getJadwal(
      forceRefresh: forceRefresh,
    );

    result.fold(
      (failure) {
        AppLogger.warning('>>> [JadwalCubit] Gagal: ${failure.message}');
        emit(
          state.copyWith(
            status: JadwalStatus.failure,
            message: failure.message,
          ),
        );
      },
      (jadwalEntity) {
        AppLogger.info('>>> [JadwalCubit] Sukses memuat data jadwal!');
        emit(
          state.copyWith(status: JadwalStatus.success, jadwal: jadwalEntity),
        );
      },
    );
  }
}
