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

enum SearchOpType { digital, nonDigital, free, paid }

enum JenisKendaraan {
  mobil(1),
  motor(2);

  final int id;

  const JenisKendaraan(this.id);
}
