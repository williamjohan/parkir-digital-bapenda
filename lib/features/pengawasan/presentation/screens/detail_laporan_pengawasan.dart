import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_typography.dart';
import 'package:parkir_digital_bapenda/core/design_system/components/pb_form_section_card.dart';

class DetailLaporanPengawasanScreen extends StatelessWidget {
  final String namaJenisPelanggaran;
  final String keterangan;
  final String? foto;

  const DetailLaporanPengawasanScreen({
    super.key,
    required this.namaJenisPelanggaran,
    required this.keterangan,
    this.foto,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 18),
        ),
        title: Text('Detail Laporan', style: AppTypography.bodySemiBold),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FormSectionCard(
            title: 'Jenis Pelanggaran',
            icon: Icons.report_problem_outlined,
            child: Text(namaJenisPelanggaran, style: AppTypography.bodyRegular),
          ),

          const SizedBox(height: 16),

          FormSectionCard(
            title: 'Keterangan',
            icon: Icons.notes_rounded,
            child: Text(keterangan, style: AppTypography.bodyRegular),
          ),

          if (foto != null && foto!.isNotEmpty) ...[
            const SizedBox(height: 16),

            FormSectionCard(
              title: 'Foto Bukti',
              icon: Icons.image_outlined,
              child: GestureDetector(
                onTap: () => _showImagePreview(context),
                child: Hero(
                  tag: 'laporan-image',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AspectRatio(
                      aspectRatio: 16 / 10,
                      child: Image.memory(
                        base64Decode(foto!),
                        fit: BoxFit.cover,
                        gaplessPlayback: true,
                        errorBuilder: (_, __, ___) => _brokenImage(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _brokenImage() {
    return Container(
      color: Colors.grey.shade200,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.broken_image_outlined,
            color: Colors.grey.shade600,
            size: 48,
          ),
          const SizedBox(height: 8),
          Text(
            'Gagal memuat gambar',
            style: AppTypography.bodySmall.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  void _showImagePreview(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(12),
          child: Stack(
            children: [
              InteractiveViewer(
                minScale: 0.8,
                maxScale: 5,
                child: Hero(
                  tag: 'laporan-image',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.memory(
                      base64Decode(foto!),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              Positioned(
                top: 12,
                right: 12,
                child: CircleAvatar(
                  backgroundColor: Colors.black54,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
