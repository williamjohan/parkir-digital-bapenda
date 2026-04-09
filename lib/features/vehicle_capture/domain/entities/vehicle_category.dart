// Misal ini adalah enum Anda
enum VehicleCategory { motor, mobil }

extension VehicleCategoryExtension on VehicleCategory {
  String get displayName {
    switch (this) {
      case VehicleCategory.motor:
        return 'Motor';
      case VehicleCategory.mobil:
        return 'Mobil';
    }
  }
}
