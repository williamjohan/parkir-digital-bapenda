import 'package:flutter/material.dart';

import 'history_item_widget.dart';

class HistoryRecapWidget extends StatelessWidget {
  const HistoryRecapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 8),
      child: Row(
        children: [
          HistoryRecapItem(title: "Roda 2", value: "0", subTitle: "Transaksi"),
          SizedBox(width: 8),
          HistoryRecapItem(title: "Roda 4", value: "0", subTitle: "Transaksi"),
          SizedBox(width: 8),
          HistoryRecapItem(title: "Total", value: "0", subTitle: "Pendapatan"),
        ],
      ),
    );
  }
}
