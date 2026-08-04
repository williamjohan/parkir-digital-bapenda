import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:parkir_digital_bapenda/features/jadwal/domain/entities/riwayat_abensi_entity.dart';
import 'package:parkir_digital_bapenda/features/jadwal/domain/usecases/riwayat_absensi_usecase.dart';
import 'package:parkir_digital_bapenda/features/jadwal/presentation/cubit/riwayat_absensi_state.dart';
import '../../../../core/utils/app_logger.dart';

@injectable
class RiwayatAbsensiCubit extends Cubit<RiwayatAbsensiState> {
  final RiwayatAbsensiUsecase _getRiwayatAbsensiUsecase;

  RiwayatAbsensiCubit(this._getRiwayatAbsensiUsecase)
    : super(const RiwayatAbsensiState());

  Future<void> fetchJadwal({
    required DateTime tglAwal,
    required DateTime tglAkhir,
  }) async {
    if (isClosed) return;

    emit(
      state.copyWith(
        status: JadwalStatus.loading,
        jadwalFake: [
          RiwayatAbsensiEntity(
            tanggal: tglAwal,
            tanggalString: '',
            objekList: List<ObjekPengawasanEntity>.generate(
              3,
              (_) => const ObjekPengawasanEntity(
                nop: '00.00.000.000.000-0000.0',
                namaNop: 'Memuat data objek pengawasan',
                shiftCheckIn: '0',
                shiftCheckOut: '0',
                jamCheckIn: '00:00',
                jamCheckOut: '00:00',
                motorCheckIn: 0,
                mobilCheckIn: 0,
                motorCheckOut: 0,
                mobilCheckOut: 0,
                instrumenCheckIn: [
                  InstrumenTersediaEntity(nama: 'EDC', tersedia: true),
                  InstrumenTersediaEntity(nama: 'QRIS', tersedia: true),
                  InstrumenTersediaEntity(nama: 'TSpark', tersedia: true),
                ],
                instrumenCheckOut: [
                  InstrumenTersediaEntity(nama: 'EDC', tersedia: true),
                  InstrumenTersediaEntity(nama: 'QRIS', tersedia: true),
                  InstrumenTersediaEntity(nama: 'TSpark', tersedia: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    AppLogger.info(
      '>>> [RiwayatAbsensiCubit] Mengeksekusi permintaan data jadwal...',
    );

    final result = await _getRiwayatAbsensiUsecase.getRiwayatAbsensiInfo(
      tglAwal: tglAwal,
      tglAkhir: tglAkhir,
    );

    if (isClosed) return;

    result.fold(
      (failure) {
        if (isClosed) return;
        AppLogger.warning(
          '>>> [RiwayatAbsensiCubit] Gagal: ${failure.message}',
        );
        emit(
          state.copyWith(
            status: JadwalStatus.failure,
            message: failure.message,
          ),
        );
      },
      (riwayatAbsensiEntity) {
        if (isClosed) return;
        AppLogger.info('>>> [RiwayatAbsensiCubit] Sukses memuat data jadwal!');
        emit(
          state.copyWith(
            status: JadwalStatus.success,
            jadwal: riwayatAbsensiEntity,
          ),
        );
      },
    );
  }
}
