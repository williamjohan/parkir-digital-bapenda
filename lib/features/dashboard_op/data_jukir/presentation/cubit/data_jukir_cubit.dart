import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../transaction/domain/usecases/get_data_jukir_usecase.dart';
import 'data_jukir_state.dart';

@injectable
class DataJukirCubit extends Cubit<DataJukirState> {
  final GetDataJukirUseCase _getDataJukirUseCase;

  DataJukirCubit(this._getDataJukirUseCase) : super(const DataJukirState());

  Future<void> getDataJukir(String nop) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final result = await _getDataJukirUseCase(nop);

      emit(state.copyWith(isLoading: false, data: result));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  void reset() {
    emit(const DataJukirState());
  }
}
