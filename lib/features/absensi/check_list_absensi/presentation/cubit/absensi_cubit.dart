import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/absensi_entity.dart';
import '../../domain/usecases/absensi_usecase.dart';
import 'absensi_state.dart';

@injectable
class AbsensiCubit extends Cubit<AbsensiState> {
  final AbsensiUsecase _usecase;

  AbsensiCubit(this._usecase) : super(const AbsensiState());

  Future<void> submitAbsensi(AbsensiEntity absensi) async {
    // 1. Emit status loading agar UI bisa menampilkan CircularProgressIndicator
    emit(
      state.copyWith(
        status: AbsensiStatus.loading,
        errorMessage: '', // Reset error message setiap kali submit baru
      ),
    );

    // 2. Panggil Usecase Facade kita
    final result = await _usecase.postAbsensi(absensi);

    // 3. Handle kembalian dari Left (Failure) atau Right (Success)
    result.fold(
      (failure) {
        if (!isClosed) {
          emit(
            state.copyWith(
              status: AbsensiStatus.failure,
              errorMessage: failure.message,
            ),
          );
        }
      },
      (_) {
        if (!isClosed) {
          emit(state.copyWith(status: AbsensiStatus.success));
        }
      },
    );
  }
}
