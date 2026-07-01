import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_colors.dart';
import 'package:parkir_digital_bapenda/core/design_system/tokens/app_typography.dart';

enum LaporanKategori {
  jukirTidakAda,
  jukirTidakSesuaiIdentitas,
  pembayaranTunai,
  lainnya;

  String get label {
    switch (this) {
      case LaporanKategori.jukirTidakAda:
        return "Jukir Tidak Ada";
      case LaporanKategori.jukirTidakSesuaiIdentitas:
        return "Jukir Tidak Menggunakan Alat Pembayaran Resmi dari Bapenda";
      case LaporanKategori.pembayaranTunai:
        return "Pembayaran Menggunakan Tunai";
      case LaporanKategori.lainnya:
        return "Lainnya";
    }
  }
}

class LaporanFormResult {
  final LaporanKategori kategori;
  final String keterangan;
  final File? photo;

  const LaporanFormResult({
    required this.kategori,
    required this.keterangan,
    this.photo,
  });
}

class LaporanFormScreen extends StatefulWidget {
  // final void Function(LaporanFormResult result) onSubmit;

  const LaporanFormScreen({super.key});

  @override
  State<LaporanFormScreen> createState() => _LaporanFormScreenState();
}

class _LaporanFormScreenState extends State<LaporanFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _keteranganController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  LaporanKategori? _kategori;
  File? _photo;

  @override
  void dispose() {
    _keteranganController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (image != null) {
      setState(() => _photo = File(image.path));
    }
  }

  void _removePhoto() {
    setState(() => _photo = null);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (_kategori == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pilih kategori laporan terlebih dahulu")),
      );
      return;
    }

    // widget.onSubmit(
    //   LaporanFormResult(
    //     kategori: _kategori!,
    //     keterangan: _keteranganController.text.trim(),
    //     photo: _photo,
    //   ),
    // );

    Navigator.of(context).pop();
  }

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
        title: Text("Buat Laporan", style: AppTypography.bodySemiBold),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSectionCard(
              title: "Kategori Laporan",
              icon: Icons.report_gmailerrorred_rounded,
              child: _buildKategoriDropdown(),
            ),
            const SizedBox(height: 16),
            _buildSectionCard(
              title: "Keterangan",
              icon: Icons.notes_rounded,
              child: TextFormField(
                controller: _keteranganController,
                maxLines: 4,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return "Keterangan wajib diisi";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "Jelaskan detail kejadian di sini...",
                  hintStyle: AppTypography.bodySmall.copyWith(
                    color: Colors.grey.shade400,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.error),
                  ),
                  contentPadding: const EdgeInsets.all(14),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionCard(
              title: "Foto (Opsional)",
              icon: Icons.camera_alt_rounded,
              child: _buildPhotoPicker(),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.send_rounded, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      "Kirim Laporan",
                      style: AppTypography.bodySemiBold.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildKategoriDropdown() {
    return DropdownButtonFormField<LaporanKategori>(
      initialValue: _kategori,
      isExpanded: true,
      decoration: InputDecoration(
        hintText: "Pilih kategori",
        hintStyle: AppTypography.bodySmall.copyWith(
          color: Colors.grey.shade400,
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
      ),
      items: LaporanKategori.values
          .map(
            (k) => DropdownMenuItem(
              value: k,
              child: Text(
                k.label,
                style: AppTypography.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
          .toList(),
      onChanged: (v) => setState(() => _kategori = v),
    );
  }

  Widget _buildPhotoPicker() {
    if (_photo == null) {
      return GestureDetector(
        onTap: _pickPhoto,
        child: Container(
          width: double.infinity,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.shade200,
              style: BorderStyle.solid,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_a_photo_rounded,
                size: 28,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 8),
              Text(
                "Ketuk untuk tambah foto",
                style: AppTypography.bodySmall.copyWith(
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          Image.file(
            _photo!,
            width: double.infinity,
            height: 180,
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: _removePhoto,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close_rounded,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(
                title,
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(height: 1, color: Colors.grey.shade100),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
