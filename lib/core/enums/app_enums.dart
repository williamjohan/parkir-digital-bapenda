/// Mewakili status pungutan tarif dari Backend (0, 1, 2)
enum PungutTarifParkir {
  tidakDiketahui(0, "Tidak Diketahui"),
  tidakBertarif(1, "Tidak Memungut Tarif"),
  bertarif(2, "BerTarif");

  final int value;
  final String description;

  const PungutTarifParkir(this.value, this.description);
  static PungutTarifParkir fromInt(int value) {
    return PungutTarifParkir.values.firstWhere(
      (e) => e.value == value,
      orElse: () => PungutTarifParkir.tidakDiketahui,
    );
  }
}

/// Mewakili ID Kendaraan dari endpoint QRIS Rompi
enum JenisKendaraanId {
  motor(1, "Mobil"),
  mobil(2, "Motor"),
  ojol(3, "Ojol"),
  tidakDiketahui(0, "Unknown");

  final int value;
  final String label;

  const JenisKendaraanId(this.value, this.label);

  static JenisKendaraanId fromInt(int value) {
    return JenisKendaraanId.values.firstWhere(
      (e) => e.value == value,
      orElse: () => JenisKendaraanId.tidakDiketahui,
    );
  }
}

enum RoleLoginDigitalParkir {
  jukir(-1, "Jukir"),
  wp(1, "Wp"),
  bapenda(2, "Bapenda"),
  pengawas(3, "Pengawas"),
  tidakDiketahui(0, "Tidak Diketahui");

  final int value;
  final String description;

  const RoleLoginDigitalParkir(this.value, this.description);

  /// Helper untuk parsing dari JSON/API dengan aman
  static RoleLoginDigitalParkir fromInt(int value) {
    return RoleLoginDigitalParkir.values.firstWhere(
      (e) => e.value == value,
      orElse: () => RoleLoginDigitalParkir.tidakDiketahui,
    );
  }
}

enum SearchOpType { digital, nonDigital, free }

enum JenisKendaraan {
  mobil(1),
  motor(2);

  final int id;

  const JenisKendaraan(this.id);
}

enum AppPermissionType {
  camera,
  location,
  locationService,
  notification,
  storage,
  photos,
  microphone,
  bluetooth,
}

enum AppPermissionStatus { granted, denied, permanentlyDenied }

enum CameraModuleIntent { absensiCheckIn, absensiCheckOut, pengawasan, unknown }

enum ShiftFormType { checkIn, checkOut }

enum ShiftPengawasan {
  shift1(id: 1, label: 'Shift 1', timeRange: '10:00 - 14:00'),
  shift2(id: 2, label: 'Shift 2', timeRange: '17:00 - 21:00');

  final int id;
  final String label;
  final String timeRange;

  const ShiftPengawasan({
    required this.id,
    required this.label,
    required this.timeRange,
  });

  static ShiftPengawasan fromId(int id) {
    return ShiftPengawasan.values.firstWhere(
      (shift) => shift.id == id,
      orElse: () => ShiftPengawasan.shift1,
    );
  }
}

enum JenisPengawasan {
  bapenda(id: 1, label: 'Bapenda'),
  dishub(id: 2, label: 'Dishub');

  final int id;
  final String label;

  const JenisPengawasan({required this.id, required this.label});

  static JenisPengawasan fromId(int id) {
    return JenisPengawasan.values.firstWhere(
      (jenis) => jenis.id == id,
      orElse: () => JenisPengawasan.bapenda,
    );
  }
}
