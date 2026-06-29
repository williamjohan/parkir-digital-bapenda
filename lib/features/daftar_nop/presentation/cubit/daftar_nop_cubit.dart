import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/storage/database_helper_2.dart';
import '../../data/mapper/daftar_nop_mapper.dart';
import '../../domain/usecases/daftar_nop_datasource.dart';
import 'daftar_nop_state.dart';

@injectable
class DaftarNopCubit extends Cubit<DaftarNopState> {
  final GetDaftarNopUsecase getDaftarNopUsecase;
  final DatabaseHelper2 databaseHelper;

  DaftarNopCubit(this.getDaftarNopUsecase, this.databaseHelper)
    : super(DaftarNopState.initial());

  Future<void> getDaftarNop() async {
    try {
      emit(state.copyWith(isLoading: true, isSuccess: false, errorMessage: ''));

      final result = await getDaftarNopUsecase();

      emit(state.copyWith(daftarNop: result, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> syncDaftarNop() async {
    try {
      emit(
        state.copyWith(
          isLoading: true,
          isSaving: true,
          progress: 0,
          errorMessage: '',
        ),
      );

      final list = await getDaftarNopUsecase();

      await databaseHelper.deleteAllNop();

      final total = list.length;

      for (int i = 0; i < total; i++) {
        await databaseHelper.insertNop(list[i].toDbMap());

        emit(state.copyWith(progress: (i + 1) / total));
      }

      emit(
        state.copyWith(
          daftarNop: list,
          isLoading: false,
          isSaving: false,
          isSuccess: true,
          progress: 1,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          isSaving: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
