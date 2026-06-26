import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:parkir_digital_bapenda/features/dashboard_op/sub_features/detail_realisasi_op/domain/usecases/get_detail_realisasi_op_usecase.dart';
import 'detail_realisasi_op_state.dart';

@injectable
class DetailRealisasiOpCubit extends Cubit<DetailRealisasiOpState> {
  final GetDetailRealisasiOpUseCase _getDetailRealisasiOpUseCase;

  Timer? _debounceTimer;
  String _currentNop = ''; // Simpan NOP di memori Cubit

  DetailRealisasiOpCubit(this._getDetailRealisasiOpUseCase)
    : super(
        DetailRealisasiOpState(
          selectedYear: DateTime.now().year,
          currentYear: DateTime.now().year,
        ),
      );
  void init(String nop) {
    _currentNop = nop;
    if (!isClosed) {
      emit(state.copyWith(isLoading: true, errorMessage: null));
    }
    _fetchDataForYear(state.selectedYear);
  }

  void decrementYear() {
    if (!state.canDecrementYear) return;

    final newYear = state.selectedYear - 1;
    emit(state.copyWith(selectedYear: newYear, isLoading: true));
    _fetchDataForYear(newYear);
  }

  void incrementYear() {
    if (!state.canIncrementYear) return;
    _changeYear(state.selectedYear + 1);
  }

  void selectYearFromBottomSheet(int year) {
    if (year > state.currentYear) return;
    _changeYear(year);
  }

  void _changeYear(int targetYear) {
    if (!isClosed) {
      emit(
        state.copyWith(
          selectedYear: targetYear,
          isLoading: true,
          errorMessage: null,
          data: null,
        ),
      );
    }

    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _fetchDataForYear(targetYear);
    });
  }

  Future<void> _fetchDataForYear(int year) async {
    if (isClosed) return;
    if (_currentNop.isEmpty) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage:
              'Sistem kehilangan data NOP OP. Silakan kembali ke halaman sebelumnya.',
        ),
      );
      return;
    }
    final result = await _getDetailRealisasiOpUseCase(
      nop: _currentNop,
      tahun: year,
    );

    if (isClosed) return;
    result.fold(
      (failureMessage) {
        emit(state.copyWith(isLoading: false, errorMessage: failureMessage));
      },
      (entityData) {
        emit(state.copyWith(isLoading: false, data: entityData));
      },
    );
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
