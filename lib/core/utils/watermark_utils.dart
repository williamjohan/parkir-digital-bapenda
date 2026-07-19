import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

class PhotoUtils {
  static Future<File?> setWatermarkImage(GlobalKey photoKey) async {
    try {
      final boundary =
          photoKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        debugPrint(
          '>>> [PHOTO UTILS ERROR] RenderRepaintBoundary tidak ditemukan pada GlobalKey',
        );
        return null;
      }

      // Render widget menjadi gambar beresolusi tinggi (pixel ratio 1.5 - 2.0 untuk ketajaman teks)
      final image = await boundary.toImage(pixelRatio: 1.5);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return null;

      final pngBytes = byteData.buffer.asUint8List();

      final dir = await getTemporaryDirectory();
      final file = File(
        '${dir.path}/watermark_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(pngBytes);

      return file;
    } catch (e, stackTrace) {
      debugPrint(
        '>>> [PHOTO UTILS ERROR] Gagal capture watermark: $e\n$stackTrace',
      );
      return null;
    }
  }

  /// Utilitas pemformatan label waktu untuk tampilan teks watermark di UI
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
