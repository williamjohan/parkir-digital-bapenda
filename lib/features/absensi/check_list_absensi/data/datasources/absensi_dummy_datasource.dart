import '../models/absensi_model.dart';

abstract class IAbsensiDataSource {
  Future<AbsensiModel> getAbsensiHariIni();
  Future<AbsensiModel> submitAbsenMasuk(AbsensiModel data);
  Future<AbsensiModel> submitAbsenPulang(AbsensiModel data);
}

class AbsensiDummyDataSource implements IAbsensiDataSource {
  // In-Memory Database (Singleton Cache)
  bool _mockIsPresent = false;
  AbsensiCheckListModel? _mockChecklist;

  @override
  Future<AbsensiModel> getAbsensiHariIni() async {
    await Future.delayed(const Duration(seconds: 1));
    return AbsensiModel(
      date: DateTime.now(),
      latitude: -7.250445,
      longitude: 112.768845,
      isPresent: _mockIsPresent,
      checkList: _mockChecklist,
    );
  }

  @override
  Future<AbsensiModel> submitAbsenMasuk(AbsensiModel data) async {
    await Future.delayed(const Duration(seconds: 2));
    _mockIsPresent = true;
    _mockChecklist = data.checkList;

    return AbsensiModel(
      date: data.date,
      latitude: data.latitude,
      longitude: data.longitude,
      isPresent: _mockIsPresent,
      checkList: _mockChecklist,
    );
  }

  @override
  Future<AbsensiModel> submitAbsenPulang(AbsensiModel data) async {
    await Future.delayed(const Duration(seconds: 2));
    // Pulang tidak mengubah state isPresent (tetap true untuk hari itu),
    // checklist bisa diabaikan atau disave tergantung kebutuhan BE.
    return AbsensiModel(
      date: data.date,
      latitude: data.latitude,
      longitude: data.longitude,
      isPresent: true,
      checkList: data.checkList,
    );
  }
}
