import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:parkir_digital_bapenda/features/pengawasan/domain/entities/laporan_pengawasan/laporan_pengawasan_entity.dart';
import '../../../../core/services/location/i_app_location_service.dart';
import '../../../../core/utils/photo_utils.dart';
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

  // 🔥 UPDATE: Langsung emit ke state.request
  void setJenisPelanggaran(int jenisPel) {
    emit(state.copyWith(request: state.request.copyWith(jenisPel: jenisPel)));
  }

  // --- LOGIC LOKASI ---
  Future<void> fetchLocation(IAppLocationService locationService) async {
    emit(state.copyWith(isFetchingLocation: true, locationError: null));
    try {
      final result = await locationService.getCurrentLocation();
      if (isClosed) return;

      emit(
        state.copyWith(
          latitude: double.tryParse(result.latitude),
          longitude: double.tryParse(result.longitude),
          placeName: result.address,
          isFetchingLocation: false,
        ),
      );
    } catch (e) {
      if (isClosed) return;
      emit(
        state.copyWith(locationError: e.toString(), isFetchingLocation: false),
      );
    }
  }

  // --- LOGIC AMBIL FOTO MENTAH ---
  Future<void> pickAndSetPhoto({
    required ImagePicker picker,
    required IAppLocationService locationService,
  }) async {
    try {
      final XFile? image = await PhotoUtils.pickPhoto(picker);
      if (image == null) return;

      emit(
        state.copyWith(
          rawPhoto: File(image.path),
          photoTakenAt: DateTime.now(),
        ),
      );

      // Otomatis langsung perbarui lokasi begitu foto didapatkan
      await fetchLocation(locationService);
    } catch (e) {
      emit(state.copyWith(errorMessage: "Gagal mengambil foto dari kamera"));
    }
  }

  // 🔥 BARU: Simpan foto yang sudah di-watermark ke dalam state.request sebelum submit
  void setWatermarkedPhoto(File watermarkedFile) {
    emit(
      state.copyWith(
        request: state.request.copyWith(buktiFoto: watermarkedFile),
      ),
    );
  }

  // 🔥 UPDATE: Bersihkan juga properti di dalam state.request saat foto dihapus
  void removePhoto() {
    emit(
      state.copyWith(
        rawPhoto: null,
        photoTakenAt: null,
        request: state.request.copyWith(buktiFoto: null),
      ),
    );
  }

  void setCapturing(bool isCapturing) {
    emit(state.copyWith(isCapturing: isCapturing));
  }

  // 🔥 UPDATE: Fungsi submit sekarang hanya butuh ketPel, sisanya membaca langsung dari state.request
  Future<void> submit(String ketPel) async {
    // Gabungkan keterangan terbaru ke dalam request final
    final finalRequest = state.request.copyWith(ketPel: ketPel.trim());

    // Validasi bisnis logic di Cubit
    if (finalRequest.buktiFoto == null) {
      emit(state.copyWith(errorMessage: 'Foto bukti wajib diambil.'));
      return;
    }

    if (finalRequest.jenisPel == 0) {
      emit(state.copyWith(errorMessage: 'Jenis pelanggaran wajib dipilih.'));
      return;
    }

    if (finalRequest.ketPel.isEmpty) {
      emit(state.copyWith(errorMessage: 'Keterangan wajib diisi.'));
      return;
    }

    emit(state.copyWith(isLoading: true, isSuccess: false, errorMessage: null));

    try {
      // Kirim objek request yang sudah lengkap
      await _addPengawasanUsecase(finalRequest);
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

  // void setFoto(File foto) {
  //   emit(state.copyWith(request: state.request.copyWith(buktiFoto: foto)));
  // }

  // void removeFoto() {
  //   emit(state.copyWith(request: state.request.copyWith(buktiFoto: null)));
  // }

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
    if (!isClosed) emit(const PengawasanState());
  }
}
