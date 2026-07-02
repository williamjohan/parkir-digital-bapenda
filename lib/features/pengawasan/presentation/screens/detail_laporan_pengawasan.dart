import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_typography.dart';
import 'package:parkir_digital_bapenda/features/pengawasan/presentation/widgets/laporan_section_card.dart';

class DetailLaporanPengawasanScreen extends StatelessWidget {
  final String namaJenisPelanggaran;
  final String keterangan;

  /// Bisa berupa:
  /// - Path file lokal (/storage/...)
  /// - Base64
  /// - null
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
          LaporanSectionCard(
            title: 'Jenis Pelanggaran',
            icon: Icons.report_problem_outlined,
            child: Text(namaJenisPelanggaran, style: AppTypography.bodyRegular),
          ),

          const SizedBox(height: 16),

          LaporanSectionCard(
            title: 'Keterangan',
            icon: Icons.notes_rounded,
            child: Text(keterangan, style: AppTypography.bodyRegular),
          ),

          if (foto != null && foto!.isNotEmpty) ...[
            const SizedBox(height: 16),

            LaporanSectionCard(
              title: 'Foto Bukti',
              icon: Icons.image_outlined,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(aspectRatio: 16 / 10, child: _buildImage()),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildImage() {
    if (foto == null || foto!.isEmpty) {
      return _brokenImage();
    }

    // File hasil kamera
    if (foto!.startsWith('/')) {
      return Image.file(
        File(foto!),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _brokenImage(),
      );
    }

    try {
      // Base64 dengan prefix data:image
      final base64String = foto!.startsWith('data:image')
          ? foto!.substring(foto!.indexOf(',') + 1)
          : foto!;

      return Image.memory(
        base64Decode(base64String),
        fit: BoxFit.cover,
        gaplessPlayback: true,
        errorBuilder: (_, __, ___) => _brokenImage(),
      );
    } catch (_) {
      return _brokenImage();
    }
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
}
