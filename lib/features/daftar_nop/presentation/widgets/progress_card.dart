import 'package:flutter/material.dart';

class ProgressCard extends StatelessWidget {
  final double progress;
  final bool isSaving;
  final bool isSuccess;

  const ProgressCard({
    super.key,
    required this.progress,
    required this.isSaving,
    required this.isSuccess,
  });

  @override
  Widget build(BuildContext context) {
    final percent = (progress * 100).toStringAsFixed(0);

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("Sinkronisasi NOP"),

            const SizedBox(height: 12),

            LinearProgressIndicator(value: progress),

            const SizedBox(height: 8),

            Text("$percent %"),

            if (isSaving)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text("Sedang menyimpan..."),
              ),

            if (isSuccess)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text("Selesai"),
              ),
          ],
        ),
      ),
    );
  }
}
