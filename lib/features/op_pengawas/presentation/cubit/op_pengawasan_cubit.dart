import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/enums/app_enums.dart';
import '../../domain/entities/op_pengawas_entity.dart';
import '../../domain/usecases/op_pengawasan_usecase.dart';
import 'op_pengawasan_state.dart';

@injectable
class OpPengawasanCubit extends Cubit<OpPengawasanState> {
  final GetOpPengawasanUseCase _getOpPengawasanUseCase;

  OpPengawasanCubit(this._getOpPengawasanUseCase)
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
