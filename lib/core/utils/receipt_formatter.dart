import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:parkir_digital_bapenda/core/utils/ticket_crypto_utils.dart';
import 'package:parkir_digital_bapenda/features/transaction_history/data/models/history_item_ui_extension.dart';
import '../../features/transaction_history/data/models/history_item_model.dart';

class ReceiptFormatter {
  static Future<List<int>> generateBytes(
    HistoryItemModel transaction,
    String deviceId,
    Map<String, dynamic>
    profile, // 🚀 [TAMBAHAN]: Wajib agar bisa cetak nama & alamat lokasi
  ) async {
    final capabilityProfile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, capabilityProfile);
    List<int> bytes = [];

    // Persiapan Variabel Data
    final String namaLokasi = profile['namaObjekPajak'] ?? "Parkiran Fulan's";
    final String alamat = profile['alamat'] ?? "Surabaya";
    final String platBersih =
        (transaction.platNumber == '-' || transaction.platNumber.isEmpty)
        ? "Tanpa Plat"
        : transaction.platNumber;

    // --- 1. BAPENDA SURABAYA (Font Besar) ---
    bytes += generator.text(
      'BAPENDA KOTA SURABAYA',
      styles: const PosStyles(
        align: PosAlign.center,
        height: PosTextSize.size2,
        width: PosTextSize.size2, // 🚀
        bold: true,
      ),
    );

    // --- 2. KARCIS PARKIR DIGITAL (Font Sedang/Normal) ---
    bytes += generator.text(
      'KARCIS PARKIR DIGITAL',
      styles: const PosStyles(align: PosAlign.center, bold: true),
    );

    // --- 3. ALAMAT LOKASI ---
    bytes += generator.text(
      namaLokasi,
      styles: const PosStyles(align: PosAlign.center),
    );
    bytes += generator.text(
      alamat,
      styles: const PosStyles(align: PosAlign.center),
    );

    // --- 4. TANGGAL ---
    bytes += generator.text(
      transaction.formattedDate,
      styles: const PosStyles(align: PosAlign.center),
    );

    // --- 5. GARIS HORIZONTAL ---
    bytes += generator.hr();

    // --- 6. TEXT 3 SEGMENT (Digabung 1 Baris Agar Hemat!) ---
    // Format: Motor * L 1234 AB * Rp2.000
    String segmen3 =
        // "${transaction.jenisTarif} * $platBersih * ${transaction.formattedNominal}";
        "${transaction.jenisTarif} * $platBersih * 5000";
    bytes += generator.text(
      segmen3,
      styles: const PosStyles(align: PosAlign.center, bold: true),
    );

    // --- 7. JARAK VERTIKAL KECIL ---
    bytes += generator.hr(); // Garis tutup atau bisa diganti feed(1)

    // --- 8. QR CODE ---
    final String encryptedUrl = TicketCryptoUtils.encryptPayload(
      orderId: transaction.orderId,
      deviceId: deviceId,
    );
    final String qrUrl =
        'https://bapenda.surabaya.go.id:7077/CongratulationTaxPayment?id=$encryptedUrl';

    // QRSize.size6 cukup ideal untuk kertas 58mm
    bytes += generator.qrcode(qrUrl, size: QRSize.size6);

    // --- 9. ID TRANSAKSI ---
    bytes += generator.text(
      ' ',
      styles: const PosStyles(height: PosTextSize.size1),
    ); // 🚀 Trik spasi tipis
    bytes += generator.text(
      transaction.orderId,
      styles: const PosStyles(align: PosAlign.center),
    );
    bytes += generator.feed(1);

    // --- 10. KATA TERIMA KASIH ---
    bytes += generator.text(
      'Terima kasih telah',
      styles: const PosStyles(align: PosAlign.center, bold: true),
    );
    bytes += generator.text(
      'membayar parkir resmi!',
      styles: const PosStyles(align: PosAlign.center),
    );

    // Jarak aman untuk disobek dari printer
    bytes += generator.feed(2);

    return bytes;
  }
}
