// lib/core/design_system/components/pb_keyboard_dismiss_wrapper.dart

import 'package:flutter/material.dart';

class PbKeyboardDismissWrapper extends StatelessWidget {
  final Widget child;

  const PbKeyboardDismissWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // Cara paling aman & modern untuk dismiss keyboard di Flutter
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: child,
    );
  }
}
