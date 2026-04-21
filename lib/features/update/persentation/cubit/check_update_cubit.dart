import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../usecases/check_update_usecase.dart';
import 'check_update_state.dart';

@injectable
class CheckUpdateCubit extends Cubit<CheckUpdateState> {
  final CheckUpdateUseCase _checkUpdateUseCase;

  CheckUpdateCubit(this._checkUpdateUseCase) : super(CheckUpdateInitial());

  Future<void> checkNow() async {
    emit(CheckUpdateLoading());
    final result = await _checkUpdateUseCase.execute();

    if (isClosed) return;

    result.fold((failure) => emit(CheckUpdateError(failure.message)), (
      updateEntity,
    ) {
      if (updateEntity != null) {
        emit(CheckUpdateAvailable(updateEntity));
      } else {
        emit(CheckUpdateUpToDate());
      }
    });
  }
}
