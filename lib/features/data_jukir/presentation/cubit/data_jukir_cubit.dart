import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../transaction/domain/usecases/get_data_jukir_usecase.dart';
import 'data_jukir_state.dart';

@injectable
class DataJukirCubit extends Cubit<DataJukirState> {
  final GetDataJukirUseCase _getDataJukirUseCase;

  DataJukirCubit(this._getDataJukirUseCase)
    : super(const DataJukirState.initial());

  Future<void> getDataJukir(String nop) async {
    emit(const DataJukirState.loading());

    try {
      final result = await _getDataJukirUseCase(nop);

      emit(DataJukirState.success(result));
    } catch (e) {
      emit(DataJukirState.error(e.toString()));
    }
  }

  void reset() {
    emit(const DataJukirState.initial());
  }
}
