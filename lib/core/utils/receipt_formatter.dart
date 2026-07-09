import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:parkir_digital_bapenda/core/utils/ticket_crypto_utils.dart';
import 'package:parkir_digital_bapenda/features/transaction_history/data/models/history_item_ui_extension.dart';
import '../../features/transaction_history/data/models/history_item_model.dart';

class ReceiptFormatter {
  static Future<List<int>> generateBytes(
    HistoryItemModel transaction,
    // String deviceId,
    // Map<String, dynamic> profile,
  ) async {
    final capabilityProfile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, capabilityProfile);
    List<int> bytes = [];
    bytes += generator.reset();
    bytes += [27, 51, 0];
    // final String namaLokasi = profile['namaObjekPajak'] ?? "Parkiran Fulan's";
    // final String alamat = profile['alamat'] ?? "Surabaya";
    bytes += generator.text(
      'Tiket Parkir',
      styles: const PosStyles(align: PosAlign.center, bold: true),
    );
    bytes += generator.text(
      'BAPENDA Kota Surabaya',
      styles: const PosStyles(align: PosAlign.center),
    );
    bytes += generator.text(
      "Nama lokasi dummy",
      styles: const PosStyles(align: PosAlign.center, bold: true),
    );
    bytes += generator.text(
      "alamat dummy",
      styles: const PosStyles(align: PosAlign.center),
    );
    bytes += generator.text(
      transaction.formattedDate,
      styles: const PosStyles(align: PosAlign.center),
    );
    bytes += generator.hr();
    final String priceText = transaction.isFreeTransaction
        ? 'Gratis'
        : transaction.formattedNominal;
    final String segmenDinamis;

    if (transaction.isNoPlate) {
      segmenDinamis = "${transaction.jenisKendaraan} - $priceText";
    } else {
      final String cleanPlat = transaction.platNumber.trim().toUpperCase();
      segmenDinamis = "${transaction.jenisKendaraan} - $cleanPlat - $priceText";
    }

    bytes += generator.text(
      segmenDinamis,
      styles: const PosStyles(align: PosAlign.center, bold: true),
    );

    bytes += generator.text('');
    final String encryptedUrl = TicketCryptoUtils.encryptPayload(
      orderId: transaction.orderId,
      deviceId: transaction.deviceId,
    );
    final String qrUrl =
        'https://bapenda.surabaya.go.id:7077/CongratulationTaxPayment?id=$encryptedUrl';
    bytes += generator.qrcode(qrUrl, size: QRSize.size5);
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

    return bytes;
  }
}
