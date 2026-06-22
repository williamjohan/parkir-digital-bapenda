import 'package:intl/intl.dart';

class NumberFormatter {
  NumberFormatter._();

  /// 1000 -> 1.000
  static String format(dynamic number, {int decimalDigits = 0}) {
    if (number == null) return '0';

    num value = 0;

    if (number is num) {
      value = number;
    } else if (number is String) {
      value = num.tryParse(number) ?? 0;
    }

    final formatter = NumberFormat.decimalPattern('id_ID');

    if (decimalDigits > 0) {
      return NumberFormat(
        '#,##0.${'0' * decimalDigits}',
        'id_ID',
      ).format(value);
    }

    return formatter.format(value);
  }

  /// 1000 + mobil -> 1.000 mobil
  static String withSuffix(
    dynamic number,
    String suffix, {
    int decimalDigits = 0,
  }) {
    return '${format(number, decimalDigits: decimalDigits)} $suffix';
  }
}
