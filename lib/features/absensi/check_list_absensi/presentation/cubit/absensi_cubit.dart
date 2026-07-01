import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/absensi_usecase.dart';
import 'absensi_state.dart';

/// Cubit ini khusus untuk GET status absensi hari ini (dipakai buat
/// nampilin isi card: sudah check in belum, checklist instrumen, dll).
/// Terpisah dari [AbsensiCheckInCubit] yang khusus buat action
/// POST check-in / check-out ke API real (dengan foto).
@injectable
class AbsensiCubit extends Cubit<AbsensiState> {
  final AbsensiUsecase _usecase;

  AbsensiCubit(this._usecase) : super(const AbsensiState.initial());

  Future<void> fetchAbsensiHariIni() async {
    emit(const AbsensiState.loading());

    final result = await _usecase.getAbsensiHariIni();

    result.fold(
      // NOTE: sesuaikan `failure.message` kalau nama propertinya beda
      // di class Failure kamu.
      (failure) => emit(AbsensiState.error(failure.message)),
      (data) => emit(AbsensiState.loaded(data)),
    );
  }
}
