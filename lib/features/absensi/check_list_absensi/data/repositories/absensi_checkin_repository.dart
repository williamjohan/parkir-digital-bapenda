import 'dart:io';
import 'package:injectable/injectable.dart';
import '../../domain/entities/absensi_checkin_entity.dart';
import '../../domain/repositories/i_absensi_checkin_repository.dart';
import '../datasources/absensi_datasource.dart';
import '../mapper/absensi_mapper.dart';

@LazySingleton(as: AbsensiCheckInRepository)
class AbsensiCheckInRepositoryImpl implements AbsensiCheckInRepository {
  final AbsensiCheckInDatasource _datasource;

  AbsensiCheckInRepositoryImpl(this._datasource);

  @override
  Future<void> checkIn(CheckInEntity entity, File fotoCheckIn) {
    return _datasource.checkIn(entity.toModel(), fotoCheckIn);
  }

  @override
  Future<void> checkOut(CheckOutEntity entity, File fotoCheckOut) {
    return _datasource.checkOut(entity.toModel(), fotoCheckOut);
  }
}