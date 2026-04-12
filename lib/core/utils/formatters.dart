class AppFormatters {
  static String nop(String rawNop) {
    String cleanNop = rawNop.replaceAll(RegExp(r'\D'), '');
    if (cleanNop.length != 18) return rawNop;

    return "${cleanNop.substring(0, 2)}.${cleanNop.substring(2, 4)}.${cleanNop.substring(4, 7)}.${cleanNop.substring(7, 10)}.${cleanNop.substring(10, 13)}.${cleanNop.substring(13, 18)}";
  }
}
