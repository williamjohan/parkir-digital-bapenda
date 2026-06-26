import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/get_realisasi_seluruh_op.dart';
import 'realisasi_state.dart';

@injectable
class RealisasiCubit extends Cubit<RealisasiState> {
  final GetRealisasiSeluruhOpUseCase getRealisasiSeluruhOpUseCase;

  RealisasiCubit(this.getRealisasiSeluruhOpUseCase)
    : super(
        RealisasiState(
          selectedYear: DateTime.now().year,
          currentYear: DateTime.now().year,
        ),
      );
  void init() {
    final year = DateTime.now().year;
    fetchData(year);
  }

  Future<void> fetchData(int tahun) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final result = await getRealisasiSeluruhOpUseCase.execute(tahun);
    result.fold(
      (error) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: error,
            data: [], // Kosongkan data jika error
          ),
        );
      },
      (data) {
        emit(state.copyWith(isLoading: false, data: data, errorMessage: null));
      },
    );
  }

  void incrementYear() {
    if (!state.canIncrementYear) return;

    final newYear = state.selectedYear + 1;
    emit(state.copyWith(selectedYear: newYear));
    fetchData(newYear);
  }

  void decrementYear() {
    if (!state.canDecrementYear) return;

    final newYear = state.selectedYear - 1;
    emit(state.copyWith(selectedYear: newYear));
    fetchData(newYear);
  }

  void selectYearFromBottomSheet(int year) {
    if (year == state.selectedYear) return;

    emit(state.copyWith(selectedYear: year));
    fetchData(year);
  }
}
