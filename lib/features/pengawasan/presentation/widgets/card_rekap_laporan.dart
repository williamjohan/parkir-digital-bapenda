import 'package:flutter/material.dart';

class CardLaporanPelanggaran extends StatelessWidget {
  final LaporanPelanggaran item;

  const CardLaporanPelanggaran({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          GestureDetector(
            onTap: () => _showImage(context, item.image),
            child: Hero(
              tag: item.image,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  item.image,
                  width: 88,
                  height: 88,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  item.date,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),

                const SizedBox(height: 8),

                Text(
                  item.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey.shade700, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showImage(BuildContext context, String image) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Hero(
            tag: image,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: InteractiveViewer(child: Image.network(image)),
            ),
          ),
        ),
      ),
    );
  }
}

class LaporanPelanggaran {
  final String image;
  final String title;
  final String description;
  final String date;

  const LaporanPelanggaran({
    required this.image,
    required this.title,
    required this.description,
    required this.date,
  });
}

final dummyLaporan = [
  const LaporanPelanggaran(
    image: "https://picsum.photos/id/1011/600/400",
    title: "Parkir di Trotoar",
    description:
        "Kendaraan roda empat parkir di atas trotoar sehingga mengganggu pejalan kaki.",
    date: "1 Juli 2026 • 09:15 WIB",
  ),
  const LaporanPelanggaran(
    image: "https://picsum.photos/id/1025/600/400",
    title: "Tidak Membayar Retribusi",
    description:
        "Pengendara meninggalkan lokasi parkir tanpa melakukan pembayaran sesuai tarif.",
    date: "1 Juli 2026 • 10:20 WIB",
  ),
  const LaporanPelanggaran(
    image: "https://picsum.photos/id/1035/600/400",
    title: "Parkir Ganda",
    description:
        "Mobil berhenti di belakang kendaraan lain sehingga menghambat akses keluar.",
    date: "1 Juli 2026 • 11:45 WIB",
  ),
  const LaporanPelanggaran(
    image: "https://picsum.photos/id/1040/600/400",
    title: "Melebihi Area Parkir",
    description: "Kendaraan diparkir melewati marka yang telah ditentukan.",
    date: "1 Juli 2026 • 12:30 WIB",
  ),
];
