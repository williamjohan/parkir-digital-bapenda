import 'dart:async';
import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/core/utils/currency_formatter.dart';
import 'package:parkir_digital_bapenda/features/transaction_history/data/models/history_item_ui_extension.dart';
import '../../../../features/transaction_history/data/models/history_item_model.dart';
import '../../tokens/app_colors.dart';
import '../pb_primary_button.dart';
import '../pb_qr_generator_widget.dart';

enum _PrintStatus { idle, printing, success, failed }

class PbPreviewTicketWidget extends StatefulWidget {
  final VoidCallback? okPressed;
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
  Timer? _resetTimer;

  late AnimationController _checkController;
  late Animation<double> _checkScale;

  @override
  void initState() {
    super.initState();
    _checkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _checkScale = CurvedAnimation(
      parent: _checkController,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _resetTimer?.cancel();
    _resetTimer = null;

    if (_checkController.isAnimating) {
      _checkController.stop(canceled: true);
    }
    _checkController.dispose();
    super.dispose();
  }

  Future<void> _handlePrint() async {
    if (_status == _PrintStatus.printing || widget.printPressed == null) return;

    _resetTimer?.cancel();

    if (mounted) {
      setState(() => _status = _PrintStatus.printing);
    }

    final success = await widget.printPressed!.call();

    // 🚀 3. DEFENSIVE CHECK: Pastikan widget masih tertancap di layar setelah async
    if (!mounted) return;

    if (success) {
      setState(() => _status = _PrintStatus.success);
      _checkController.forward(from: 0);

      _resetTimer = Timer(const Duration(milliseconds: 1800), () {
        // 🚀 4. DOUBLE GUARD: Jangan panggil setState jika dialog sudah ditutup tombol OK
        if (mounted) {
          setState(() => _status = _PrintStatus.idle);
        }
      });
    } else {
      setState(() => _status = _PrintStatus.failed);

      _resetTimer = Timer(const Duration(milliseconds: 1600), () {
        if (mounted) {
          setState(() => _status = _PrintStatus.idle);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _buildCard(context),

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
          const Text(
            "Tiket Parkir",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const Text("BAPENDA Kota Surabaya"),

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

          const Text(
            "ID TRANSAKSI",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          Text(item.orderId, textAlign: TextAlign.center),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                // 🚀 NONAKTIFKAN TOMBOL OK SAAT PROSES CETAK BERJALAN
                child: PbPrimaryButton(
                  text: "OK",
                  onPressed: _status == _PrintStatus.printing
                      ? null
                      : widget.okPressed,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(child: _buildPrintButton()),
            ],
          ),
        ],
      ),
    );
  }

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
