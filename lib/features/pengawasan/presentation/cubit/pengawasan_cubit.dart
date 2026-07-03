import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:parkir_digital_bapenda/features/pengawasan/domain/entities/laporan_pengawasan/laporan_pengawasan_entity.dart';
import '../../domain/constants/jenis_pelanggaran_dummy.dart';
import '../../domain/usecases/pengawasan_usecase.dart';
import 'pengawasan_state.dart';

@injectable
class PengawasanCubit extends Cubit<PengawasanState> {
  final AddPengawasanUsecase _addPengawasanUsecase;
  final GetLaporanPengawasanUsecase _getLaporanPengawasanUsecase;

  PengawasanCubit(this._addPengawasanUsecase, this._getLaporanPengawasanUsecase)
    : super(const PengawasanState());

  void loadJenisPelanggaran() {
    emit(state.copyWith(jenisPelanggaran: dummyJenisPelanggaran));
  }

  void setJenisPelanggaran(int jenisPel) {
    emit(state.copyWith(request: state.request.copyWith(jenisPel: jenisPel)));
  }

  void setFoto(File foto) {
    emit(state.copyWith(request: state.request.copyWith(buktiFoto: foto)));
  }

  void removeFoto() {
    emit(state.copyWith(request: state.request.copyWith(buktiFoto: null)));
  }

  Future<void> submit(String ketPel) async {
    final request = state.request.copyWith(ketPel: ketPel.trim());

    if (request.jenisPel == 0) {
      if (!isClosed) {
        emit(state.copyWith(errorMessage: 'Jenis pelanggaran wajib dipilih.'));
      }
      return;
    }

    if (request.ketPel.isEmpty) {
      if (!isClosed) {
        emit(state.copyWith(errorMessage: 'Keterangan wajib diisi.'));
      }
      return;
    }

    if (request.buktiFoto == null) {
      if (!isClosed) {
        emit(state.copyWith(errorMessage: 'Foto bukti wajib diunggah.'));
      }
      return;
    }

    if (!isClosed) {
      emit(
        state.copyWith(isLoading: true, isSuccess: false, errorMessage: null),
      );
    }

    try {
      await _addPengawasanUsecase(request);

      if (isClosed) return;

      emit(state.copyWith(isLoading: false, isSuccess: true));
    } catch (e) {
      if (isClosed) return;

      emit(
        state.copyWith(
          isLoading: false,
          isSuccess: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> getLaporanPengawasan() async {
    if (!isClosed) {
      emit(
        state.copyWith(
          isLoadingLaporan: true,
          errorMessage: null,
          laporanFake: List<LaporanPengawasanEntity>.generate(
            4,
            (_) => LaporanPengawasanEntity(
              idEvent: 0,
              op: "",
              nip: "",
              tglRoster: DateTime(2000, 1, 1),
              jadwalMasuk: DateTime(2000, 1, 1),
              jenisPel: 0,
              ketPel: "",
              insDate: DateTime(2000, 1, 1),
              insBy: "",
              seq: 0,
            ),
          ),
        ),
      );
    }

    try {
      final result = await _getLaporanPengawasanUsecase();

      if (isClosed) return;

      emit(state.copyWith(isLoadingLaporan: false, laporan: result));
    } catch (e) {
      if (isClosed) return;

      emit(state.copyWith(isLoadingLaporan: false, errorMessage: e.toString()));
    }
  }

  void reset() {
    if (isClosed) return;
    emit(const PengawasanState());
  }
}
