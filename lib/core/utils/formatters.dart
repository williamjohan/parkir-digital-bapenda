import 'package:flutter/services.dart';

class AppFormatters {
  static String nop(String rawNop) {
    String cleanNop = rawNop.replaceAll(RegExp(r'\D'), '');
    if (cleanNop.length != 18) return rawNop;

    return "${cleanNop.substring(0, 2)}.${cleanNop.substring(2, 4)}.${cleanNop.substring(4, 7)}.${cleanNop.substring(7, 10)}.${cleanNop.substring(10, 13)}.${cleanNop.substring(13, 18)}";
  }
}

class NopInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // ambil angka saja
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    // limit 18 digit
    if (digits.length > 18) {
      digits = digits.substring(0, 18);
    }

    // format bertahap
    String formatted = '';

    for (int i = 0; i < digits.length; i++) {
      formatted += digits[i];

      if (i == 1 || i == 3 || i == 6 || i == 9 || i == 12) {
        if (i != digits.length - 1) {
          formatted += '.';
        }
      }
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
