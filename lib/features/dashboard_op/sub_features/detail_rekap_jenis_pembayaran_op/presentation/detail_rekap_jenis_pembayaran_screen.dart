import 'package:flutter/material.dart';

import '../../../domain/entities/dashboard_op_entity.dart';
import 'widgets/card_soft_widget.dart';

class DetailRekapJenisPembayaranScreen extends StatelessWidget {
  final List<SofEntity> data;

  const DetailRekapJenisPembayaranScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rekap Metode Pembayaran')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: data.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return CardSofWidget(item: data[index]);
        },
      ),
    );
  }
}
