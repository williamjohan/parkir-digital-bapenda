import 'package:flutter/material.dart';
import 'package:flutter_classic_bluetooth/flutter_classic_bluetooth.dart';
import '../../../../core/design_system/tokens/app_colors.dart'; // Sesuaikan path

class DeviceItemCard extends StatelessWidget {
  final BtcDevice device;
  final bool isConnected;
  final bool isLoading;
  final VoidCallback onConnect;

  const DeviceItemCard({
    super.key,
    required this.device,
    required this.isConnected,
    required this.isLoading,
    required this.onConnect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5), //
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10), //
      decoration: BoxDecoration(
        color: isConnected
            ? AppColors.success.withValues(alpha: 0.06)
            : Colors.white, //
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isConnected
              ? AppColors.success.withValues(alpha: 0.35)
              : Colors.grey.shade200,
          width: 1.2,
        ),
        boxShadow: isConnected
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Row(
        children: [
          // --- Gradient Avatar ---
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isConnected
                    ? [
                        AppColors.success,
                        AppColors.success.withValues(alpha: 0.75),
                      ]
                    : [
                        AppColors.primary.withValues(alpha: 0.14),
                        AppColors.primary.withValues(alpha: 0.05),
                      ],
              ),
            ),
            child: Icon(
              isConnected ? Icons.print_rounded : Icons.bluetooth_rounded,
              color: isConnected ? Colors.white : AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          // --- Text Info ---
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  device.displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  device.address,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    letterSpacing: .2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // --- Action Button / Status ---
          isConnected
              ? Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        size: 14,
                        color: AppColors.success,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Aktif',
                        style: TextStyle(
                          color: AppColors.success,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox(
                  height: 36,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : onConnect,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Konek',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
