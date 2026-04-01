// lib/core/utils/transaction_id_utils.dart

import 'dart:math';
import 'package:intl/intl.dart';

class TransactionIdUtils {
  /// Menghasilkan Order ID yang ramah manusia.
  /// Contoh: PRK-MOT-20260401-1430-A1B2
  static String generateOrderId({
    required String kategoriKendaraan,
    required int modePlat,
  }) {
    final now = DateTime.now();

    // 1. Format Tanggal & Jam (Contoh: 20260401-1430)
    final dateStr = DateFormat('yyyyMMdd-HHmm').format(now);

    // 2. Kategori (MOT untuk Motor, MOB untuk Mobil)
    final kat = kategoriKendaraan.toUpperCase().length >= 3
        ? kategoriKendaraan.toUpperCase().substring(0, 3)
        : 'UNK';

    // 3. Prefix Mode (QP = Quick Park/Tanpa Plat, CP = Capture Park/Pakai Plat)
    final prefix = 'PARK';

    // 4. Random 4 Karakter Alfanumerik (Mencegah bentrok jika transaksi di detik yang sama)
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    final randomStr = String.fromCharCodes(
      Iterable.generate(
        4,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );

    return '$prefix-$kat-$dateStr-$randomStr';
  }
}
