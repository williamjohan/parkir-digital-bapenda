import 'package:flutter/material.dart';

import '../../domain/entities/daftar_nop_entity.dart';

class DaftarNopList extends StatelessWidget {
  final List<DaftarNopEntity> data;
  final bool isLoading;

  const DaftarNopList({super.key, required this.data, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    if (isLoading && data.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (data.isEmpty) {
      return const Center(child: Text("Tidak ada data"));
    }

    return ListView.separated(
      itemCount: data.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (_, index) {
        final item = data[index];

        return ListTile(
          title: Text(item.namaOp),
          subtitle: Text(item.alamatOp),
          trailing: Text(item.nop),
        );
      },
    );
  }
}
