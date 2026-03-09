class ApiEndpoints {
  ApiEndpoints._();

  // Endpoint khusus Modul Auth
  static const String login = '/auth/login';
  static const String refreshToken = '/auth/refresh';

  // Endpoint khusus Modul Kendaraan
  static const String submitPlate = '/vehicle/submit';
  static const String getHistory = '/vehicle/history';
}
