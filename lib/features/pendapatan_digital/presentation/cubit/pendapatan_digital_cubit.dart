import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:parkir_digital_bapenda/features/home/domain/usecases/home_usecase.dart';
import 'pendapatan_digital_state.dart';

@injectable
class PendapatanDigitalCubit extends Cubit<PendapatanDigitalState> {
  final HomeUsecase _homeusecase;

  PendapatanDigitalCubit(this._homeusecase)
    : super(const PendapatanDigitalState());

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

    final result = await _homeusecase.getDashboardSummaryNonJukirRange(
      tglAwal: tglAwal,
      tglAkhir: tglAkhir,
    );

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
