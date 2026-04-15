// lib/core/utils/transaction_id_utils.dart

import 'package:intl/intl.dart';

class TransactionIdUtils {
  static String generateOrderId() {
    final now = DateTime.now();

    // Format
    // yyyy = Year (4 digit)
    // MM = Month (2 digit)
    // dd = Day (2 digit)
    // HH = Hour 24-format (2 digit)
    // mm = Minute (2 digit)
    // ss = Second (2 digit)
    return DateFormat('yyyyMMddHHmmss').format(now);
  }
}
