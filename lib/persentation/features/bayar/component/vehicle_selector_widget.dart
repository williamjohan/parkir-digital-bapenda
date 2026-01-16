import 'package:flutter/material.dart';

class VehicleSelectorWidget extends StatelessWidget {
  final String selectedType;
  final Function(String) onChanged;

  const VehicleSelectorWidget({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildCard("Mobil", Icons.directions_car)),
        const SizedBox(width: 16),
        Expanded(child: _buildCard("Motor", Icons.two_wheeler)),
      ],
    );
  }

  Widget _buildCard(String type, IconData icon) {
    final bool isSelected = selectedType == type;

    return GestureDetector(
      onTap: () => onChanged(type),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(color: Colors.blueAccent, width: 2)
              : Border.all(color: Colors.transparent),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: const Color(0xFF5566FF)),
            const SizedBox(height: 8),
            Text(
              type,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
