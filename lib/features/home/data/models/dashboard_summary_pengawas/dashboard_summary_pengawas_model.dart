import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/dashboard_summary_pengawas.entity.dart';

part 'dashboard_summary_pengawas_model.freezed.dart';
part 'dashboard_summary_pengawas_model.g.dart';

/// 1. CLASS UTAMA (ROOT RESPONSE)
@freezed
class DashboardSummaryPengawasModel with _$DashboardSummaryPengawasModel {
  const factory DashboardSummaryPengawasModel({
    @Default(false) bool isSuccess,
    @Default(0) int statusCode,
    @Default('') String message,
    @Default(DashboardDataModel()) DashboardDataModel data,
  }) = _DashboardSummaryPengawasModel;

  factory DashboardSummaryPengawasModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardSummaryPengawasModelFromJson(json);
}

/// 2. CLASS DATA UTAMA
@freezed
class DashboardDataModel with _$DashboardDataModel {
  const factory DashboardDataModel({
    @Default(0) int laporanPelanggaran,
    @Default(DashboardInfoModel()) DashboardInfoModel dashboard,
    @Default(CheckInOutModel()) CheckInOutModel checkInOut,
  }) = _DashboardDataModel;

  factory DashboardDataModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardDataModelFromJson(json);
}

/// 3. CLASS DASHBOARD (Isi dari object "dashboard")
@freezed
class DashboardInfoModel with _$DashboardInfoModel {
  const factory DashboardInfoModel({
    @Default(0) int jumlahMotorHariIni,
    @Default(0) int jumlahMobilHariIni,
    @Default(0) int totalNominalHariIni,
    @Default(0) int totalNominalBersihUntukWajibPajak,
    @Default(0) int totalNominalBersihUntukBapenda,
  }) = _DashboardInfoModel;

  factory DashboardInfoModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardInfoModelFromJson(json);
}

/// 4. CLASS CHECK IN OUT (Isi dari object "checkInOut")
@freezed
class CheckInOutModel with _$CheckInOutModel {
  const factory CheckInOutModel({
    @Default(0) int idEvent,
    @Default('') String op,
    @Default('') String nip,
    @Default('') String tglRoster,
    @Default('') String jadwalMasuk,
    @Default('') String jadwalOut,
    @Default(0) int status,
    @Default('') String checkIn,
    @Default('') String checkInString,
    @Default(0) int checkInJmlMobil,
    @Default(0) int checkInJmlMotor,
    @Default('') String checkOut,
    @Default('') String checkOutString,
    @Default(0) int checkOutJmlMobil,
    @Default(0) int checkOutJmlMotor,
    @Default('') String latitude,
    @Default('') String longitude,
    @Default([]) List<DetailAlatModel> detailAlatCheckIn,
    @Default([]) List<DetailAlatModel> detailAlatCheckOut,
  }) = _CheckInOutModel;

  factory CheckInOutModel.fromJson(Map<String, dynamic> json) =>
      _$CheckInOutModelFromJson(json);
}

@freezed
class DetailAlatModel with _$DetailAlatModel {
  const factory DetailAlatModel({
    @Default(0) int alatId,
    @Default('') String nama,
    @Default(true) bool isBawa,
  }) = _DetailAlatModel;

  factory DetailAlatModel.fromJson(Map<String, dynamic> json) =>
      _$DetailAlatModelFromJson(json);
}

// Extension khusus List untuk mapping mudah
extension DetailAlatModelListExt on List<DetailAlatModel> {
  List<DetailAlatEntity> toEntityList() {
    return map((model) => model.toEntity()).toList();
  }
}

extension DashboardPengawasanModelExt on DashboardSummaryPengawasModel {
  DashboardSummaryPengawasEntity toEntity() {
    return DashboardSummaryPengawasEntity(
      isSuccess: isSuccess,
      statusCode: statusCode,
      message: message,
      data: data.toEntity(),
    );
  }
}

extension DashboardDataModelExt on DashboardDataModel {
  DashboardDataEntity toEntity() {
    return DashboardDataEntity(
      laporanPelanggaran: laporanPelanggaran,
      dashboard: dashboard.toEntity(),
      checkInOut: checkInOut.toEntity(),
    );
  }
}

extension DashboardInfoModelExt on DashboardInfoModel {
  DashboardInfoEntity toEntity() {
    return DashboardInfoEntity(
      jumlahMotorHariIni: jumlahMotorHariIni,
      jumlahMobilHariIni: jumlahMobilHariIni,
      totalNominalHariIni: totalNominalHariIni,
      totalNominalBersihUntukWajibPajak: totalNominalBersihUntukWajibPajak,
      totalNominalBersihUntukBapenda: totalNominalBersihUntukBapenda,
    );
  }
}

extension CheckInOutModelExt on CheckInOutModel {
  CheckInOutEntity toEntity() {
    return CheckInOutEntity(
      idEvent: idEvent,
      op: op,
      nip: nip,
      tglRoster: tglRoster,
      jadwalMasuk: jadwalMasuk,
      jadwalOut: jadwalOut,
      status: status,
      checkIn: checkIn,
      checkInString: checkInString,
      checkInJmlMobil: checkInJmlMobil,
      checkInJmlMotor: checkInJmlMotor,
      checkOut: checkOut,
      checkOutString: checkOutString,
      checkOutJmlMobil: checkOutJmlMobil,
      checkOutJmlMotor: checkOutJmlMotor,
      latitude: latitude,
      longitude: longitude,
      detailAlatCheckIn: detailAlatCheckIn.toEntityList(),
      detailAlatCheckOut: detailAlatCheckOut.toEntityList(),
    );
  }
}

extension DetailAlatModelExt on DetailAlatModel {
  DetailAlatEntity toEntity() {
    return DetailAlatEntity(id: alatId, namaAlat: nama, isBawa: isBawa);
  }
}
