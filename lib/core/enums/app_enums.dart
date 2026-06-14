/// Mewakili status pungutan tarif dari Backend (0, 1, 2)
enum PungutTarifParkir {
  tidakDiketahui(0, "Tidak Diketahui"),
  tidakBertarif(1, "Tidak Memungut Tarif"), // Ini yang isFree = true
  bertarif(2, "BerTarif");

  final int value;
  final String description;

  const PungutTarifParkir(this.value, this.description);

  // Helper untuk parsing dari JSON/API dengan aman
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
