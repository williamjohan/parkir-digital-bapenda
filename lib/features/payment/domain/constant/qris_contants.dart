class QrisDemoConstants {
  QrisDemoConstants._();
  static const String nopId = "01828";
  static const String obyekPajak = "P. BU RUDY";
  static const String shift = "01";

  /// QRIS Value untuk Kendaraan 1 (MOBIL)
  /// Nominal yang ter-encode biasanya menyesuaikan tarif mobil Bapenda
  static const String qrisMobil =
      "00020101021226710019ID.CO.BANKJATIM.WWW01189360011400002505540215ID20260025051600303URE51450015ID.OR.GPNQR.WWW0215ID20265308828960303UME520493995303360540450005802ID5923PARKIR BAPENDA KOTA SBY6008SURABAYA6105601116229012500000000000000000318375916304B41F";

  /// QRIS Value untuk Kendaraan 2 (MOTOR)
  /// Nominal yang ter-encode biasanya menyesuaikan tarif motor Bapenda
  static const String qrisMotor =
      "00020101021226710019ID.CO.BANKJATIM.WWW01189360011400002505540215ID20260025051600303URE51450015ID.OR.GPNQR.WWW0215ID20265308828960303UME520493995303360540420005802ID5923PARKIR BAPENDA KOTA SBY6008SURABAYA61056011162290125000000000000000003183759363048191";

  /// Helper function untuk mendapatkan QRIS berdasarkan tipe kendaraan
  /// 1 = Mobil, 2 = Motor
  static String getQrisByVehicleType(int type) {
    switch (type) {
      case 1:
        return qrisMobil;
      case 2:
        return qrisMotor;
      default:
        return qrisMotor; // Fallback aman ke Motor
    }
  }
}
