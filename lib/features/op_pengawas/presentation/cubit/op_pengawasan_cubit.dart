import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/storage/app_preferences.dart';
import '../../domain/entities/op_pengawas_entity.dart';
import '../../domain/usecases/op_pengawasan_usecase.dart';
import 'op_pengawasan_state.dart';

@injectable
class OpPengawasanCubit extends Cubit<OpPengawasanState> {
  final GetOpPengawasanUseCase _getOpPengawasanUseCase;
  final AppPreferences _appPreferences;

  OpPengawasanCubit(this._getOpPengawasanUseCase, this._appPreferences)
    : super(const OpPengawasanState());

  Future<void> getOpPengawasan() async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: null,
        opPengawasanList: _dummySkeleton,
        filteredOpPengawasanList: _dummySkeleton,
      ),
    );

    try {
      final result = await _getOpPengawasanUseCase();

      if (isClosed) return;

      emit(
        state.copyWith(
          isLoading: false,
          opPengawasanList: result,
          filteredOpPengawasanList: result,
        ),
      );
    } catch (e) {
      if (isClosed) return;

      emit(
        state.copyWith(
          isLoading: false,
          opPengawasanList: const [],
          filteredOpPengawasanList: const [],
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> selectObjekPengawasan(OpPengawasEntity item) async {
    if (isClosed) return;

    await Future.wait([
      _appPreferences.saveJenisObjekPengawasan(item.jenisPengawasan),
      _appPreferences.saveAlamatObjekPengawasan(item.alamat),
      _appPreferences.saveNomorObjekPengawasan(item.nop),
      _appPreferences.saveNamaObjekPengawasan(item.namaOp),
    ]);
  }

  static final List<OpPengawasEntity> _dummySkeleton = List.generate(
    8,
    (_) => const OpPengawasEntity(
      kecamatan: 'Kecamatan',
      namaOp: 'Nama Objek Pajak',
      jenisPengawasan: JenisPengawasan.bapenda,
      nop: '357813000190704537',
      alamat: 'Jl. Lorem Ipsum No.123',
    ),
  );
  void search(String keyword) {
    final query = keyword.trim().toLowerCase();

    if (query.isEmpty) {
      emit(state.copyWith(filteredOpPengawasanList: state.opPengawasanList));
      return;
    }

    final result = state.opPengawasanList.where((item) {
      return item.namaOp.toLowerCase().contains(query) ||
          item.alamat.toLowerCase().contains(query);
    }).toList();

    emit(state.copyWith(filteredOpPengawasanList: result));
  }

  void filter(JenisPengawasan? jenis) {
    if (jenis == null) {
      emit(state.copyWith(filteredOpPengawasanList: state.opPengawasanList));
      return;
    }

    final result = state.opPengawasanList.where((item) {
      return item.jenisPengawasan == jenis;
    }).toList();

    emit(state.copyWith(filteredOpPengawasanList: result));
  }

  void searchAndFilter({required String keyword, JenisPengawasan? jenis}) {
    List<OpPengawasEntity> result = state.opPengawasanList;

    if (jenis != null) {
      result = result.where((e) => e.jenisPengawasan == jenis).toList();
    }

    final query = keyword.trim().toLowerCase();

    if (query.isNotEmpty) {
      result = result.where((item) {
        return item.namaOp.toLowerCase().contains(query) ||
            item.alamat.toLowerCase().contains(query);
      }).toList();
    }

    emit(state.copyWith(filteredOpPengawasanList: result));
  }
}
