import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/pengawasan_entity.dart';
import '../../domain/usecases/pengawasan_usecase.dart';
import 'pengawasan_state.dart';

@injectable
class PengawasanCubit extends Cubit<PengawasanState> {
  final AddPengawasanUsecase _addPengawasanUsecase;

  PengawasanCubit(this._addPengawasanUsecase) : super(const PengawasanState());

  Future<void> addPengawasan(PengawasanEntity entity, File buktiFoto) async {
    emit(state.copyWith(isLoading: true, isSuccess: false, errorMessage: null));

    try {
      await _addPengawasanUsecase(entity, buktiFoto);

      emit(state.copyWith(isLoading: false, isSuccess: true));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          isSuccess: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void reset() {
    emit(const PengawasanState());
  }
}
