import 'dart:convert';

import 'package:flutter/widgets.dart';

class QrisImgWidget extends StatelessWidget {
  final String base64String;
  const QrisImgWidget({super.key, required this.base64String});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRect(
        child: Align(
          alignment: Alignment.center,
          widthFactor: 0.8, // 👈 crop kiri kanan (0.8 = ambil 80%)
          child: Image.memory(
            base64Decode(base64String),
            fit: BoxFit.cover,
            height: 400,
          ),
        ),
      ),
    );
  }
}
