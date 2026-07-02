class AppLocationData {
  final String latitude;
  final String longitude;
  final String? address; // Tambahan untuk nama jalan (opsional)

  AppLocationData({
    required this.latitude,
    required this.longitude,
    this.address,
  });
}
