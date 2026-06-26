import 'package:flutter/material.dart';
import 'liquid_loading_animation_widget.dart';

class AppLoadingWidget extends StatelessWidget {
  final double size;
  final String? message;

  const AppLoadingWidget({super.key, this.size = 150, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LiquidLoadingWidget(size: size, durationSeconds: 2.5),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 0.5,
                decoration: TextDecoration.none,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
