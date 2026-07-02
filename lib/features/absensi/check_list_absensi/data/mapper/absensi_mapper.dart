import 'package:parkir_digital_bapenda/features/absensi/check_list_absensi/domain/entities/absensi_checkin_entity.dart';

import '../../domain/entities/absensi_entity.dart';
import '../models/alat_item_model.dart';
import '../models/checkin_model.dart';
import '../models/checkout_model.dart';

extension CheckInEntityMapper on CheckInEntity {
  CheckInModel toModel() {
    return CheckInModel(
      checkInJmlMobil: jumlahMobil,
      checkInJmlMotor: jumlahMotor,
      latitude: latitude,
      longitude: longitude,
      detailAlatList: detailAlat.map((e) => AlatItemModel(id: e.id)).toList(),
    );
  }
}

extension CheckOutEntityMapper on CheckOutEntity {
  CheckOutModel toModel() {
    return CheckOutModel(
      checkOutJmlMobil: jumlahMobil,
      checkOutJmlMotor: jumlahMotor,
      latitude: latitude,
      longitude: longitude,
      detailAlatList: detailAlat.map((e) => AlatItemModel(id: e.id)).toList(),
    );
  }
}
