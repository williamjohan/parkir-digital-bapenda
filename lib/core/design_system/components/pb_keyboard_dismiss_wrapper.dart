import 'package:flutter/material.dart';

class PbKeyboardDismissWrapper extends StatelessWidget {
  final Widget child;

  const PbKeyboardDismissWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: child,
    );
  }
}
