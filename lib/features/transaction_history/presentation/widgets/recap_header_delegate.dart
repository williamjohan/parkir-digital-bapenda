import 'package:flutter/material.dart';

import '../cubit/transaction_history_state.dart';
import 'hidtory_recap_widget.dart';

class RecapHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final TransactionHistoryLoaded state;
  final bool isFree;
  final VoidCallback onTapExpand;

  RecapHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.state,
    required this.isFree,
    required this.onTapExpand,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final progress = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);

    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          // 🔹 EXPANDED
          Opacity(
            opacity: 1 - progress,
            child: Transform.scale(
              scale: 1 - (progress * 0.1),
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: FittedBox(
                  // 🔥 anti overflow
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: HistoryRecapWidget(
                      roda2: state.roda2.toString(),
                      roda4: state.roda4.toString(),
                      totalPendapatan: state.totalPendapatan.toString(),
                      isFree: isFree,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 🔹 COLLAPSED
          Opacity(
            opacity: progress,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.center,
                child: _buildCollapsed(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollapsed() {
    final total = state.roda2 + state.roda4;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (!isFree)
              Text(
                "Rp${state.totalPendapatan}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            const SizedBox(width: 8),
            Text("$total transaksi"),
          ],
        ),
        TextButton(onPressed: onTapExpand, child: const Text("Lihat Rekap")),
      ],
    );
  }

  @override
  bool shouldRebuild(covariant RecapHeaderDelegate oldDelegate) => true;
}
