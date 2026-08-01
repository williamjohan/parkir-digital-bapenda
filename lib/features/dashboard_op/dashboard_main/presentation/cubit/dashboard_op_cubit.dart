import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/dashboard_op_usecase.dart';
import 'dashboard_op_state.dart';

@injectable
class DashboardOpCubit extends Cubit<DashboardOpState> {
  final GetSummaryDashboardOpUsecase _usecase;

  DashboardOpCubit(this._usecase) : super(DashboardOpState.initial());

  Future<void> getSummaryDashboardOp(String nop) async {
    try {
      emit(state.copyWith(loading: true, errorMessage: null));

      final result = await _usecase(nop);

      if (isClosed) return;

      result.fold(
        (failure) {
          emit(state.copyWith(loading: false, errorMessage: failure.message));
        },
        (dashboard) {
          emit(
            state.copyWith(
              loading: false,
              data: dashboard,
              showTSCard: _usecase.getTSInfo(dashboard),
            ),
          );
        },
      );

      debugPrint('isDigital = ${state.data?.isDigital}');
    } catch (e) {
      if (isClosed) return;

      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }
}
