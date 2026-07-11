import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/core/utils/currency_formatter.dart';
import 'package:parkir_digital_bapenda/features/transaction_history/data/models/history_item_ui_extension.dart';
import '../../../../features/transaction_history/data/models/history_item_model.dart';
import '../../tokens/app_colors.dart';
import '../pb_primary_button.dart';
import '../pb_qr_generator_widget.dart';

enum _PrintStatus { idle, printing, success, failed } // 🚀 BARU

class PbPreviewTicketWidget extends StatefulWidget {
  final VoidCallback? okPressed;
  // 🚀 GANTI: dulu VoidCallback, sekarang wajib return Future<bool> —
  // true kalau print sukses, false kalau gagal, biar widget ini bisa
  // nampilin animasi loading -> sukses/gagal sendiri.
  final Future<bool> Function()? printPressed;
  final HistoryItemModel item;
  final bool isPrinterReady;

  const PbPreviewTicketWidget({
    super.key,
    required this.okPressed,
    required this.printPressed,
    required this.item,
    required this.isPrinterReady,
  });

  @override
  State<PbPreviewTicketWidget> createState() => _PbPreviewTicketWidgetState();
}

class _PbPreviewTicketWidgetState extends State<PbPreviewTicketWidget>
    with SingleTickerProviderStateMixin {
  _PrintStatus _status = _PrintStatus.idle;

  late final AnimationController _checkController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 450),
  );
  late final Animation<double> _checkScale = CurvedAnimation(
    parent: _checkController,
    curve: Curves.elasticOut,
  );

  @override
  void dispose() {
    _checkController.dispose();
    super.dispose();
  }

  Future<void> _handlePrint() async {
    if (_status == _PrintStatus.printing || widget.printPressed == null) return;

    setState(() => _status = _PrintStatus.printing);

    final success = await widget.printPressed!.call();
    if (!mounted) return;

    if (success) {
      setState(() => _status = _PrintStatus.success);
      _checkController.forward(from: 0);

      // Balik ke tombol normal abis animasinya keliatan user —
      // biar bisa cetak ulang kalau mau (misal salah kertas, dsb).
      Future.delayed(const Duration(milliseconds: 1800), () {
        if (mounted) setState(() => _status = _PrintStatus.idle);
      });
    } else {
      setState(() => _status = _PrintStatus.failed);
      Future.delayed(const Duration(milliseconds: 1600), () {
        if (mounted) setState(() => _status = _PrintStatus.idle);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _buildCard(context),

        // 🚀 BARU: overlay checkmark hijau yang nutupin card pas sukses cetak
        if (_status == _PrintStatus.success)
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedOpacity(
                opacity: 1,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.94),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: ScaleTransition(
                      scale: _checkScale,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 76,
                            height: 76,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.success,
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 44,
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'Berhasil Dicetak!',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: AppColors.success,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCard(BuildContext context) {
    final item = widget.item;

    return Container(
      constraints: const BoxConstraints(maxWidth: 350),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// HEADER
          const Text(
            "Tiket Parkir",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const Text("BAPENDA Kota Surabaya"),

          /// INFO LOKASI
          Text(
            item.namaOp,
            style: const TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(item.alamatOp, textAlign: TextAlign.center),
          const SizedBox(height: 6),
          Text(item.formattedDate),

          const SizedBox(height: 12),
          const Divider(),

          /// DETAIL KENDARAAN
          Text.rich(
            TextSpan(
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              children: [
                TextSpan(text: item.jenisTarif),
                const TextSpan(
                  text: '  •  ',
                  style: TextStyle(color: Colors.grey),
                ),
                TextSpan(text: CurrencyFormatter.toIdr(item.kredit)),
              ],
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          /// QR CODE
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              border: Border.all(color: AppColors.primary, width: 2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: PbQrCodeGenerateWidget(url: item.encUrl, size: 200),
          ),

          const SizedBox(height: 12),

          /// ID TRANSAKSI
          const Text(
            "ID TRANSAKSI",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          Text(item.orderId, textAlign: TextAlign.center),

          const SizedBox(height: 16),

          /// BUTTONS
          Row(
            children: [
              Expanded(
                child: PbPrimaryButton(text: "OK", onPressed: widget.okPressed),
              ),
              const SizedBox(width: 8),
              Expanded(child: _buildPrintButton()),
            ],
          ),
        ],
      ),
    );
  }

  // 🚀 BARU: tombol cetak sekarang 4 wajah — idle, printing, failed, success
  // (success dihandle di overlay, tombolnya sendiri balik ke bentuk idle)
  Widget _buildPrintButton() {
    if (!widget.isPrinterReady) {
      return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade600,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 13),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: widget.printPressed == null ? null : _handlePrint,
        icon: const Icon(Icons.bluetooth_disabled, size: 18),
        label: const FittedBox(
          child: Text(
            "Hubungkan",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    switch (_status) {
      case _PrintStatus.printing:
        return ElevatedButton(
          onPressed: null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary.withValues(alpha: 0.6),
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 13),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              color: Colors.white,
            ),
          ),
        );

      case _PrintStatus.failed:
        return ElevatedButton.icon(
          onPressed: _handlePrint,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade600,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 13),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          icon: const Icon(Icons.refresh_rounded, size: 18),
          label: const FittedBox(
            child: Text(
              "Gagal, Coba Lagi",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        );

      case _PrintStatus.success:
      case _PrintStatus.idle:
        return PbPrimaryButton(
          text: "Cetak",
          iconRight: Icons.print,
          onPressed: _handlePrint,
        );
    }
  }
}
