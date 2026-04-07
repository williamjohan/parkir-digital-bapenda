import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:parkir_digital_bapenda/core/utils/ticket_crypto_utils.dart';
import 'package:parkir_digital_bapenda/features/transaction_history/data/models/history_item_ui_extension.dart';
import '../../features/transaction_history/data/models/history_item_model.dart';

class ReceiptFormatter {
  static Future<List<int>> generateBytes(
    HistoryItemModel transaction,
    String deviceId,
  ) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    List<int> bytes = [];

    // --- HEADER ---
    bytes += generator.text(
      'BAPENDA SURABAYA',
      styles: const PosStyles(
        align: PosAlign.center,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
        bold: true,
      ),
    );
    bytes += generator.text(
      'KARCIS PARKIR DIGITAL',
      styles: const PosStyles(align: PosAlign.center, bold: true),
    );

    bytes += generator.feed(1);
    bytes += generator.hr();

    // 🚀 [PERBAIKAN 1 & 2]: Menggunakan String Format manual agar tidak auto-wrap.
    // Menyelaraskan spasi agar "TANGGAL", "PLAT", dan "PETUGAS" rata kiri dan sejajar titik duanya.

    final String platBersih = transaction.subtitleText
        .replaceAll(RegExp(r'\s*\(\s*'), '(')
        .replaceAll(RegExp(r'\s*\)\s*'), ')')
        .trim();

    bytes += generator.text(
      'TANGGAL : ${transaction.formattedDate}',
      styles: const PosStyles(bold: true),
    );
    bytes += generator.text(
      'PLAT    : $platBersih',
      styles: const PosStyles(bold: true),
    );
    bytes += generator.text(
      'PETUGAS : ${transaction.namaPetugasBersih}',
      styles: const PosStyles(bold: true),
    );

    bytes += generator.hr();

    // --- TOTAL BAYAR ---
    bytes += generator.text(
      'TOTAL BAYAR',
      styles: const PosStyles(align: PosAlign.center, bold: true),
    );
    bytes += generator.text(
      transaction.formattedNominal,
      styles: const PosStyles(
        align: PosAlign.center,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
        bold: true,
      ),
    );

    bytes += generator.text(
      '(${transaction.badgeText})',
      styles: const PosStyles(align: PosAlign.center),
    );

    bytes += generator.hr();
    bytes += generator.feed(1);

    // --- QR CODE ---
    final String encryptedUrl = TicketCryptoUtils.encryptPayload(
      orderId: transaction.orderId,
      deviceId: deviceId,
    );
    final String qrUrl =
        'https://bapenda.surabaya.go.id:7077/CongratulationTaxPayment?id=$encryptedUrl';

    bytes += generator.qrcode(qrUrl, size: QRSize.size6);

    bytes += generator.feed(1);

    // --- FOOTER ---
    bytes += generator.text(
      'Terima kasih telah',
      styles: const PosStyles(align: PosAlign.center),
    );
    bytes += generator.text(
      'membayar parkir resmi!',
      styles: const PosStyles(align: PosAlign.center),
    );

    bytes += generator.feed(1);
    bytes += generator.hr();
    bytes += generator.feed(3);

    return bytes;
  }
}
