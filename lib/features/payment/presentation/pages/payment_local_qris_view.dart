import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gal/gal.dart';
import '../../../../core/design_system/components/pb_status_snackbar.dart';
import '../widgets/payment_auto_verify_info.dart';
import '../widgets/payment_info_badge.dart';
import '../widgets/payment_instruction.dart';
import '../widgets/payment_qris_card.dart';

class PaymentLocalQrisView extends StatefulWidget {
  final Widget qrWidget;
  final String kategoriKendaraan;
  final bool showTimer;

  const PaymentLocalQrisView({
    super.key,
    required this.qrWidget,
    required this.kategoriKendaraan,
    this.showTimer = true,
  });

  @override
  State<PaymentLocalQrisView> createState() => _PaymentLocalQrisViewState();
}

class _PaymentLocalQrisViewState extends State<PaymentLocalQrisView> {
  final GlobalKey _qrisCardKey = GlobalKey();
  bool _isDownloading = false;
  bool _isCapturing = false;

  Future<void> _downloadQris() async {
    if (_isDownloading) return;
    setState(() => _isDownloading = true);

    try {
      setState(() => _isCapturing = true);
      await WidgetsBinding.instance.endOfFrame;

      final boundary =
          _qrisCardKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;

      if (boundary == null) {
        throw Exception('Gagal menemukan tampilan QRIS');
      }
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (mounted) setState(() => _isCapturing = false);

      if (byteData == null) {
        throw Exception('Gagal memproses gambar QRIS');
      }

      final Uint8List pngBytes = byteData.buffer.asUint8List();
      final hasAccess = await Gal.hasAccess();
      if (!hasAccess) {
        final granted = await Gal.requestAccess();
        if (!granted) {
          throw Exception('Akses galeri ditolak');
        }
      }
      final fileName =
          'QRIS_${widget.kategoriKendaraan.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}';

      await Gal.putImageBytes(pngBytes, name: fileName);

      if (!mounted) return;
      PbStatusSnackbar.show(
        context,
        message: "QRIS berhasil disimpan ke galeri",
      );
    } catch (e) {
      if (!mounted) return;
      PbStatusSnackbar.show(
        context,
        message: 'Gagal menyimpan QRIS: ${e.toString()}',
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isDownloading = false;
          _isCapturing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        children: [
          PaymentInfoBadge(
            label: 'Jenis Kendaraan',
            value: widget.kategoriKendaraan,
            kategoriKendaraan: widget.kategoriKendaraan,
          ),
          const SizedBox(height: 20),

          RepaintBoundary(
            key: _qrisCardKey,
            child: PaymentQrisCard(
              qrWidget: widget.qrWidget,
              isDownloading: _isDownloading,
              isCapturing: _isCapturing,
              showTimer: widget.showTimer,
              onDownloadTap: _downloadQris,
            ),
          ),

          const SizedBox(height: 20),
          const PaymentInstruction(),

          const SizedBox(height: 16),
          const PaymentAutoVerifyInfo(),
        ],
      ),
    );
  }
}
