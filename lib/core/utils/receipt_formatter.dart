// lib/features/printer/utils/receipt_formatter.dart

import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:parkir_digital_bapenda/core/utils/ticket_crypto_utils.dart';
// Pastikan path extension ini benar
import 'package:parkir_digital_bapenda/features/transaction_history/data/models/history_item_ui_extension.dart';
import '../../features/transaction_history/data/models/history_item_model.dart';

class ReceiptFormatter {
  static Future<List<int>> generateBytes(
    HistoryItemModel transaction,
    String deviceId,
    Map<String, dynamic> profile,
  ) async {
    final capabilityProfile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, capabilityProfile);
    List<int> bytes = [];

    // 🔥 PERUBAHAN 1: Reset printer untuk hilangkan default spacing atas
    bytes += generator.reset();

    // 🔥 PERUBAHAN 2: Set line spacing minimum (biar lebih rapat)
    bytes += [27, 51, 0];

    // ==========================================
    // 🚀 [PERBAIKAN CLEAN CODE]: Persiapan Variabel Data
    // ==========================================
    final String namaLokasi = profile['namaObjekPajak'] ?? "Parkiran Fulan's";
    final String alamat = profile['alamat'] ?? "Surabaya";

    // --- 1. Tiket Parkir ---
    bytes += generator.text(
      'Tiket Parkir',
      styles: const PosStyles(align: PosAlign.center, bold: true),
    );

    // --- 2. BAPENDA Kota Surabaya ---
    bytes += generator.text(
      'BAPENDA Kota Surabaya',
      styles: const PosStyles(align: PosAlign.center),
    );

    // --- 3. LOKASI ---
    bytes += generator.text(
      namaLokasi,
      styles: const PosStyles(align: PosAlign.center, bold: true),
    );

    // --- 4. ALAMAT ---
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

    // ==========================================
    // --- 6. TEXT SEGMENT (Dinamis 2 atau 3 Elemen) ---
    // ==========================================
    final String priceText = transaction.isFreeTransaction
        ? 'Gratis'
        : transaction.formattedNominal;
    final String segmenDinamis;

    if (transaction.isNoPlate) {
      // Skenario Tanpa Plat (Hanya 2 Elemen)
      // Contoh: "Mobil - Gratis" atau "Mobil - Rp 5.000"
      segmenDinamis = "${transaction.jenisKendaraan} - $priceText";
    } else {
      // Skenario Ada Plat (3 Elemen)
      // Contoh: "Mobil - L 231 AB - Gratis" atau "Mobil - L 231 AB - Rp 5.000"
      final String cleanPlat = transaction.platNumber.trim().toUpperCase();
      segmenDinamis = "${transaction.jenisKendaraan} - $cleanPlat - $priceText";
    }

    bytes += generator.text(
      segmenDinamis,
      styles: const PosStyles(align: PosAlign.center, bold: true),
    );

    bytes += generator.text('');

    // --- 7. QR CODE ---
    final String encryptedUrl = TicketCryptoUtils.encryptPayload(
      orderId: transaction.orderId,
      deviceId: deviceId,
    );
    final String qrUrl =
        'https://bapenda.surabaya.go.id:7077/CongratulationTaxPayment?id=$encryptedUrl';

    // QRSize.size6 cukup ideal untuk kertas 58mm
    bytes += generator.qrcode(qrUrl, size: QRSize.size5);

    // 🔥 PERUBAHAN 4: Kontrol jarak setelah QR (cukup 1 line)
    // bytes += generator.feed(1);

    // --- 9. ID TRANSAKSI ---
    bytes += generator.text('');

    bytes += generator.text(
      'ID TRANSAKSI',
      styles: const PosStyles(align: PosAlign.center),
    );

    bytes += generator.text(
      transaction.orderId,
      styles: const PosStyles(align: PosAlign.center),
    );

    bytes += generator.text('');
    bytes += generator.text('');
    // 🔥 PERUBAHAN 5: Kontrol jarak bawah + cut;
    // bytes += generator.cut();

    return bytes;
  }
}
