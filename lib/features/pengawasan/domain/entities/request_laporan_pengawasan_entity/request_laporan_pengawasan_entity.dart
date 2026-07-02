import 'dart:io';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'request_laporan_pengawasan_entity.freezed.dart';

@freezed
class RequestLaporanPengawasanEntity with _$RequestLaporanPengawasanEntity {
  const factory RequestLaporanPengawasanEntity({
    @Default(0) int jenisPel,
    @Default('') String ketPel,
    File? buktiFoto,
  }) = _RequestLaporanPengawasanEntity;
}
