import 'dart:io';

import '../entities/absensi_checkin_entity.dart';

abstract class AbsensiCheckInRepository {
  Future<void> checkIn(CheckInEntity entity, File fotoCheckIn);
  Future<void> checkOut(CheckOutEntity entity, File fotoCheckOut);
}
