import 'dart:io';
import 'package:injectable/injectable.dart';
import '../entities/absensi_checkin_entity.dart';
import '../repositories/i_absensi_checkin_repository.dart';

@LazySingleton()
class CheckInUsecase {
  final AbsensiCheckInRepository _repository;

  CheckInUsecase(this._repository);

  Future<void> call(CheckInEntity entity, File fotoCheckIn) {
    return _repository.checkIn(entity, fotoCheckIn);
  }
}
