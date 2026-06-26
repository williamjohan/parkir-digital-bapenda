import 'package:flutter/material.dart';

class FilterHeaderWidget extends StatelessWidget {
  final int selectedYear;
  final bool canIncrement;
  final bool canDecrement;
  final VoidCallback onDecrementYear;
  final VoidCallback onIncrementYear;
  final VoidCallback onTapTahun;

  const FilterHeaderWidget({
    super.key,
    required this.selectedYear,
    required this.canIncrement,
    required this.canDecrement,
    required this.onDecrementYear,
    required this.onIncrementYear,
    required this.onTapTahun,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFEBEBEB)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _NavButton(
              icon: Icons.chevron_left,
              onTap: canDecrement ? onDecrementYear : () {},
              isActive: canDecrement,
            ),
            Expanded(
              child: GestureDetector(
                onTap: onTapTahun,
                behavior: HitTestBehavior.opaque,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        selectedYear.toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C3E50),
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_drop_down_rounded,
                        color: Color(0xFF95A5A6),
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _NavButton(
              icon: Icons.chevron_right,
              onTap: canIncrement ? onIncrementYear : () {},
              isActive: canIncrement,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isActive;

  const _NavButton({
    required this.icon,
    required this.onTap,
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isActive ? onTap : null,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          border: Border.all(
            color: isActive ? const Color(0xFFEBEBEB) : Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Icon(
          icon,
          size: 24,
          color: isActive
              ? const Color(0xFF2C3E50)
              : const Color(0xFFDCDCDC), // Warna pudar jika mati
        ),
      ),
    );
  }
}
