class AppLocationData {
  final String latitude;
  final String longitude;
  final String? address;

  AppLocationData({
    required this.latitude,
    required this.longitude,
    this.address,
  });
}
