import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/absensi_checkin_entity.dart';
import '../../domain/usecases/absensi_checkin_usecase.dart';
import '../../domain/usecases/absensi_checkout_usecase.dart';
import 'absensi_checkin_state.dart';

@injectable
class AbsensiCheckInCubit extends Cubit<AbsensiCheckInState> {
  final CheckInUsecase _checkInUsecase;
  final CheckOutUsecase _checkOutUsecase;

  AbsensiCheckInCubit(this._checkInUsecase, this._checkOutUsecase)
    : super(const AbsensiCheckInState());

  Future<void> checkIn(CheckInEntity entity, File fotoCheckIn) async {
    emit(
      state.copyWith(
        isCheckInLoading: true,
        isCheckInSuccess: false,
        checkInErrorMessage: null,
      ),
    );

    try {
      await _checkInUsecase(entity, fotoCheckIn);

      emit(state.copyWith(isCheckInLoading: false, isCheckInSuccess: true));
    } catch (e) {
      emit(
        state.copyWith(
          isCheckInLoading: false,
          isCheckInSuccess: false,
          checkInErrorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> checkOut(CheckOutEntity entity, File fotoCheckOut) async {
    emit(
      state.copyWith(
        isCheckOutLoading: true,
        isCheckOutSuccess: false,
        checkOutErrorMessage: null,
      ),
    );

    try {
      await _checkOutUsecase(entity, fotoCheckOut);

      emit(state.copyWith(isCheckOutLoading: false, isCheckOutSuccess: true));
    } catch (e) {
      emit(
        state.copyWith(
          isCheckOutLoading: false,
          isCheckOutSuccess: false,
          checkOutErrorMessage: e.toString(),
        ),
      );
    }
  }

  void reset() {
    emit(const AbsensiCheckInState());
  }
}
