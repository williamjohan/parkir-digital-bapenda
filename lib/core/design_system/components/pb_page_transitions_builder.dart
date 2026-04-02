import 'package:flutter/material.dart';

class PbSlidePageTransitionsBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // Sesuai instruksi: Muncul slide ke kanan (Dari Kiri [-1.0] ke Tengah [0.0])
    // Saat pop (kembali), otomatis akan slide ke kiri.
    const begin = Offset(-1.0, 0.0);
    const end = Offset.zero;

    var tween = Tween(
      begin: begin,
      end: end,
    ).chain(CurveTween(curve: Curves.easeInOutCubic));

    return SlideTransition(position: animation.drive(tween), child: child);
  }
}
