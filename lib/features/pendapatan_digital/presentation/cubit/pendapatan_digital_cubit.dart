import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../home/domain/usecases/get_dashboard_summary_non_jukir_range_usecase.dart';
import 'pendapatan_digital_state.dart';

@injectable
class PendapatanDigitalCubit extends Cubit<PendapatanDigitalState> {
  final GetDashboardSummaryNonJukirRangeUseCase _useCase;

  PendapatanDigitalCubit(this._useCase) : super(const PendapatanDigitalState());

  Future<void> getSummary({String? tglAwal, String? tglAkhir}) async {
    if (isClosed) return;

    final isFirstLoad = state.summary == null;

    emit(
      state.copyWith(
        isLoading: isFirstLoad,
        isFilterLoading: !isFirstLoad,
        errorMessage: null,
      ),
    );

    final result = await _useCase.execute(tglAwal: tglAwal, tglAkhir: tglAkhir);

    if (isClosed) return;

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isLoading: false,
            isFilterLoading: false,
            errorMessage: failure.message,
          ),
        );
      },
      (data) {
        emit(
          state.copyWith(
            isLoading: false,
            isFilterLoading: false,
            summary: data,
            tglAwal: tglAwal,
            tglAkhir: tglAkhir,
            errorMessage: null,
          ),
        );
      },
    );
  }

  Future<void> refresh() async {
    if (isClosed) return;

    await getSummary(tglAwal: state.tglAwal, tglAkhir: state.tglAkhir);
  }
}
