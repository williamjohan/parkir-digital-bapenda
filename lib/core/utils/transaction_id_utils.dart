import 'package:intl/intl.dart';

class TransactionIdUtils {
  static String generateOrderId() {
    final now = DateTime.now();
    return DateFormat('yyyyMMddHHmmss').format(now);
  }
}
