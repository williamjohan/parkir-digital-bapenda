import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/utils/app_logger.dart';
import '../../../domain/usecases/home_usecase.dart';
import 'jukir_counter_state.dart';

@injectable
class JukirCounterCubit extends Cubit<JukirCounterState> {
  final HomeUsecase _usecase;

  JukirCounterCubit(this._usecase) : super(const JukirCounterState());

  Future<void> fetchInitialCounter() async {
    AppLogger.info('>>> [JUKIR COUNTER] Memulai fetch data awal...');
    emit(state.copyWith(status: JukirCounterStatus.loading));

    final result = await _usecase.getCounterData();

    if (isClosed) {
      AppLogger.debug('>>> [JUKIR COUNTER] Fetch selesai, tapi Cubit sudah closed. Aborting.');
      return;
    }

    result.fold(
      (failure) {
        AppLogger.error('>>> [JUKIR COUNTER] Fetch Gagal: ${failure.message}');
        emit(state.copyWith(
          status: JukirCounterStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (data) {
        AppLogger.debug('>>> [JUKIR COUNTER] Fetch Sukses: Mobil=${data.jumlahMobil}, Motor=${data.jumlahMotor}');
        emit(state.copyWith(
          status: JukirCounterStatus.success,
          mobilCount: data.jumlahMobil,
          motorCount: data.jumlahMotor,
        ));
      },
    );
  }

  Future<void> submitCounter(String jenisKendaraan) async {
    AppLogger.info('>>> [JUKIR COUNTER] Menyiapkan Submit untuk: $jenisKendaraan');
    
    // Cegah double-tap
    if (state.status == JukirCounterStatus.submitting) return;

    emit(state.copyWith(status: JukirCounterStatus.submitting));

    final int payloadMobil = jenisKendaraan == 'Mobil' ? 1 : 0;
    final int payloadMotor = jenisKendaraan == 'Motor' ? 1 : 0;

    AppLogger.debug('>>> [JUKIR COUNTER] Payload -> Mobil: $payloadMobil | Motor: $payloadMotor');

    final result = await _usecase.insertCounterData(
      jumlahMobil: payloadMobil,
      jumlahMotor: payloadMotor,
    );

    // 🚀 EDGE CASE GUARD: Cek apakah Cubit sudah mati akibat user exit saat loading lemot
    if (isClosed) {
      return;
    }

    result.fold(
      (failure) {
        AppLogger.error('>>> [JUKIR COUNTER] Submit Gagal: ${failure.message}');
        emit(state.copyWith(
          status: JukirCounterStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (_) {

        emit(state.copyWith(
          status: JukirCounterStatus.submitSuccess,
          mobilCount: state.mobilCount + payloadMobil,
          motorCount: state.motorCount + payloadMotor,
        ));
      },
    );
  }
}