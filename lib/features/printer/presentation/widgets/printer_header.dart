import 'package:flutter/material.dart';

class GovernmentSectionHeader extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final Color color;
  final bool isScanning;

  const GovernmentSectionHeader({
    super.key,
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
    this.isScanning = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: isScanning
                ? SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: color,
                    ),
                  )
                : Icon(icon, size: 14, color: color),
          ),
          const SizedBox(width: 8),
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: color,
              fontSize: 12,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(width: 8),

          // Badge Count (Desain asli Anda)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$count',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
