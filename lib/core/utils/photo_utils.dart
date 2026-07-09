import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class PhotoUtils {
  /// Fungsi untuk memilih foto dari kamera
  static Future<XFile?> pickPhoto(ImagePicker picker) async {
    return await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
  }

  /// Fungsi untuk meng-capture RepaintBoundary (foto + watermark) menjadi 1 file PNG
  static Future<File?> captureWatermarkedImage(GlobalKey photoKey) async {
    try {
      final boundary =
          photoKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;

      final image = await boundary.toImage(pixelRatio: 1.5);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return null;

      final pngBytes = byteData.buffer.asUint8List();

      final dir = await getTemporaryDirectory();
      final file = File(
        '${dir.path}/laporan_watermarked_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(pngBytes);

      return file;
    } catch (e) {
      debugPrint('Gagal capture watermark: $e');
      return null;
    }
  }

  /// Fungsi untuk memformat tanggal ke string watermark
  static String formatStampTime(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Ags',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return "${dt.day} ${months[dt.month - 1]} ${dt.year}, $h:$m";
  }
}
