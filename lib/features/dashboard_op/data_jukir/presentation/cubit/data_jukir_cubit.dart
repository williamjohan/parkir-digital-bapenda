import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../transaction/domain/usecases/get_data_jukir_usecase.dart';
import '../../domain/entities/data_jukir_entity.dart';
import 'data_jukir_state.dart';

@injectable
class DataJukirCubit extends Cubit<DataJukirState> {
  final GetDataJukirUseCase _getDataJukirUseCase;

  DataJukirCubit(this._getDataJukirUseCase) : super(const DataJukirState());

  Future<void> getDataJukir(String nop) async {
    if (!isClosed) {
      emit(
        state.copyWith(
          isLoading: true,
          errorMessage: null,
          dataFake: List<DataJukirEntity>.generate(
            5,
            (_) => const DataJukirEntity(
              idDevice: '',
              petugas: 'Loading...',
              shift: '',
              totalMobilHariIni: 0,
              totalMotorHariIni: 0,
              totalNominalMobilHariIni: 0,
              totalNominalMotorHariIni: 0,
              totalKendaraan: 0,
              totalNominal: 0,
              usernameList: [
                UsernameEntity(username: '', namaPetugas: '', fotoBase64: ''),
                UsernameEntity(username: '', namaPetugas: '', fotoBase64: ''),
              ],
            ),
          ),
        ),
      );
    }

    try {
      final data = await _getDataJukirUseCase(nop);

      if (!isClosed) {
        emit(state.copyWith(isLoading: false, data: data, dataFake: const []));
      }
    } catch (e) {
      if (!isClosed) {
        emit(
          state.copyWith(
            isLoading: false,
            dataFake: const [],
            errorMessage: e.toString(),
          ),
        );
      }
    }
  }

  void reset() {
    emit(const DataJukirState());
  }
}
