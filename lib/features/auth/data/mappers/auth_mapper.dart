// Catatan William
// Mapper ini digunakan untuk mengconvert DTO
// AUTH response ke Sqlite

import '../models/auth_response_model.dart';

class AuthMapper {
  /// Transformasi dari DTO API ke format Map SQLite
  static List<Map<String, dynamic>> toSqliteList(List<NopModel> nopList) {
    return nopList
        .map(
          (e) => {
            'nop': e.nop.trim(),
            'nama_op': e.namaOp,
            'alamat_op': e.alamatOp,
          },
        )
        .toList();
  }
}
