import 'package:freezed_annotation/freezed_annotation.dart';

part 'jenis_pelanggaran_entity.freezed.dart';

@freezed
class JenisPelanggaranEntity with _$JenisPelanggaranEntity {
  const factory JenisPelanggaranEntity({
    required int id,
    required String nama,
  }) = _JenisPelanggaranEntity;
}
