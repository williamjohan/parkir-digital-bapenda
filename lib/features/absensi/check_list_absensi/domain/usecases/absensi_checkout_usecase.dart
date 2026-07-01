import 'dart:io';
import 'package:injectable/injectable.dart';
import '../entities/absensi_checkin_entity.dart';
import '../repositories/i_absensi_checkin_repository.dart';

@LazySingleton()
class CheckOutUsecase {
  final AbsensiCheckInRepository _repository;

  CheckOutUsecase(this._repository);

  Future<void> call(CheckOutEntity entity, File fotoCheckOut) {
    return _repository.checkOut(entity, fotoCheckOut);
  }
}
