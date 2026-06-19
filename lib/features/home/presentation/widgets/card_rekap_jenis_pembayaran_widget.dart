import 'package:flutter/material.dart';

import '../../domain/entities/dashboard_summary_non_jukir_entity.dart';

class CardRekapJenisPembayaranWidget extends StatelessWidget {
  final List<SofParkirResultEntity> data;

  const CardRekapJenisPembayaranWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: data.length,
        separatorBuilder: (_, __) => const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Divider(height: 1),
        ),
        itemBuilder: (context, index) {
          final item = data[index];

          return Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  item.sof,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              Expanded(
                flex: 2,
                child: itemKendaraan(
                  total: item.nominalMotor,
                  jmlMotor: item.jumlahMotor,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                flex: 2,
                child: itemKendaraan(
                  total: item.nominalMobil,
                  jmlMobil: item.jumlahMobil,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

Widget itemKendaraan({int? jmlMotor, int? jmlMobil, required double total}) {
  final isMotor = jmlMotor != null;

  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        "Rp ${total.toString()}",
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 4),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(isMotor ? jmlMotor.toString() : jmlMobil.toString()),
          const SizedBox(width: 4),
          Icon(isMotor ? Icons.two_wheeler : Icons.directions_car, size: 16),
        ],
      ),
    ],
  );
}
