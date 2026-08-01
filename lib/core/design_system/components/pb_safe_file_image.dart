import 'dart:io';
import 'package:flutter/material.dart';

class PbSafeFileImage extends StatelessWidget {
  final File file;
  final BoxFit fit;
  final double? width;
  final double? height;

  const PbSafeFileImage({
    super.key,
    required this.file,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Validasi Sinkron: Cegah Fatal Crash sebelum dirender
    if (!file.existsSync() || file.lengthSync() == 0) {
      return _buildErrorPlaceholder();
    }

    // 2. Render dengan penangkap error asinkron
    return Image.file(
      file,
      fit: fit,
      width: width,
      height: height,
      errorBuilder: (context, error, stackTrace) {
        return _buildErrorPlaceholder();
      },
    );
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      width: width ?? double.infinity,
      height: height ?? double.infinity,
      color: Colors.grey.shade200,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.broken_image_rounded, color: Colors.grey, size: 32),
            SizedBox(height: 4),
            Text(
              "File rusak/hilang",
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
