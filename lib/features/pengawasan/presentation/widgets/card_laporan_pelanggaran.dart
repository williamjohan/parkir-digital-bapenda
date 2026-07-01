import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/constants/jenis_pelanggaran_dummy.dart';
import '../../domain/entities/laporan_pengawasan/laporan_pengawasan_entity.dart';

class CardLaporanPelanggaran extends StatelessWidget {
  final LaporanPengawasanEntity item;
  final VoidCallback? onTapLaporan;

  const CardLaporanPelanggaran({super.key, required this.item,required this.onTapLaporan});

  @override
  Widget build(BuildContext context) {
    final jenisPelanggaran = dummyJenisPelanggaran
        .where((e) => e.id == item.jenisPel)
        .firstOrNull;

    return GestureDetector(
      onTap: onTapLaporan,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .04),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.fotoPelaporan != null)
              GestureDetector(
                onTap: () => _showImage(context),
                child: Hero(
                  tag: 'laporan-${item.idEvent}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.memory(
                      item.fotoPelaporan!,
                      width: 88,
                      height: 88,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )
            else
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.image_not_supported_outlined),
              ),
      
            const SizedBox(width: 14),
      
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    jenisPelanggaran?.nama ?? 'Jenis Pelanggaran Tidak Diketahui',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
      
                  const SizedBox(height: 4),
      
                  Text(
                    DateFormat('dd MMM yyyy HH:mm', 'id_ID').format(item.insDate),
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
      
                  const SizedBox(height: 8),
      
                  Text(
                    item.ketPel,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey.shade700, height: 1.4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showImage(BuildContext context) {
    if (item.fotoPelaporan == null) return;

    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Hero(
            tag: 'laporan-${item.idEvent}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: InteractiveViewer(
                child: Image.memory(item.fotoPelaporan!),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
