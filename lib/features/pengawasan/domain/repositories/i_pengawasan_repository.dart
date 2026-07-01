import 'dart:io';

import '../entities/pengawasan_entity.dart';

abstract class PengawasanRepository {
  Future<void> addPengawasan(PengawasanEntity entity, File buktiFoto);
}
