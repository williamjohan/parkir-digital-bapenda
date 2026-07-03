import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkir_digital_bapenda/features/dashboard_op/data_jukir/presentation/cubit/data_jukir_cubit.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../core/design_system/tokens/app_colors.dart';
import '../../../../../core/design_system/tokens/app_typography.dart';
import '../../domain/entities/data_jukir_entity.dart';
import '../cubit/data_jukir_state.dart';

class DataJukirListScreen extends StatefulWidget {
  final String nop;

  const DataJukirListScreen({super.key, required this.nop});

  @override
  State<DataJukirListScreen> createState() => _DataJukirListScreenState();
}

class _DataJukirListScreenState extends State<DataJukirListScreen> {
  Future<void> _loadData() async {
    await context.read<DataJukirCubit>().getDataJukir(widget.nop);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'Daftar Jukir',
          style: AppTypography.heading5.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        scrolledUnderElevation: 0,
        shape: Border(bottom: BorderSide(color: AppColors.primary, width: 1.0)),
        elevation: 0,
        foregroundColor: Colors.black,
        iconTheme: IconThemeData(color: AppColors.primary),
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: _loadData,
        child: BlocBuilder<DataJukirCubit, DataJukirState>(
          builder: (context, state) {
            if (state.data.isEmpty && !state.isLoading) {
              return const Center(child: Text("Tidak ada data"));
            }

            final items = state.isLoading ? state.dataFake : state.data;

            // Menggabungkan (flatten) semua Jukir dari berbagai shift menjadi satu list
            final allJukir = items.expand((dataJukir) {
              return dataJukir.usernameList.map(
                (user) => (user: user, shift: dataJukir.shift),
              );
            }).toList();

            return Skeletonizer(
              enabled: state.isLoading,
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: allJukir.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, index) {
                  final jukirData = allJukir[index];

                  // Mengakses record menggunakan nama variabel yang didefinisikan di map
                  return _JukirCard(
                    item: jukirData.user,
                    shift: jukirData.shift,
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class _JukirCard extends StatelessWidget {
  const _JukirCard({required this.item, required this.shift});

  final UsernameEntity item;
  final String shift;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        // border: BorderSide(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. Profile Image dengan ring border, CLICKABLE
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(
                    28 + 2.5,
                  ), // Area ripple sesuai ukuran avatar+border
                  onTap: () {
                    final bytes = _ProfileImage._decodeImage(item.fotoBase64);
                    if (bytes != null) {
                      _showPhotoPreviewModal(context, bytes);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // border: BorderSide(color: Colors.blue.shade100, width: 2.5),
                    ),
                    child: _ProfileImage(base64: item.fotoBase64),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // 2. Info Text (Nama & Username)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.namaPetugas,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                      // CHANGED: Namanya max 2 line
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.badge_outlined,
                          size: 14,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            item.username,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // 3. Shift Badge dipindah ke kanan
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  // border: BorderSide(color: Colors.blue.shade100, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.access_time_filled,
                      size: 14,
                      color: Colors.blue.shade700,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Shift $shift',
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ADDED: Helper method untuk menampilkan modal preview foto
  void _showPhotoPreviewModal(BuildContext context, Uint8List bytes) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor:
              Colors.transparent, // Agar background stack bisa terlihat
          insetPadding:
              EdgeInsets.zero, // Minimal padding agar modal terlihat penuh
          child: Stack(
            alignment: Alignment.center,
            children: [
              GestureDetector(
                // Menutup modal dengan mengetuk di luar area gambar
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  color: Colors.black.withValues(alpha: 0.6),
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: InteractiveViewer(
                      // Memperbolehkan zoom dan pan pada gambar
                      child: ClipRRect(
                        // Memberikan sudut melengkung pada gambar modal
                        borderRadius: BorderRadius.circular(16),
                        child: Image.memory(
                          bytes,
                          width:
                              MediaQuery.of(context).size.width *
                              0.8, // 80% lebar layar
                          fit: BoxFit.contain, // Menjaga rasio aspek
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24), // Jarak di bawah gambar
                  ElevatedButton.icon(
                    // Tombol tutup
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                    label: const Text('Tutup'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24), // Jarak di bawah tombol
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ProfileImage extends StatelessWidget {
  const _ProfileImage({required this.base64});

  final String base64;

  // CHANGED: Menjadi static method agar bisa dipanggil dari _JukirCard
  static Uint8List? _decodeImage(String value) {
    try {
      var image = value;

      if (image.contains(',')) {
        image = image.split(',').last;
      }

      return base64Decode(image);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bytes = _decodeImage(base64);

    if (bytes == null) {
      return const CircleAvatar(radius: 28, child: Icon(Icons.person));
    }

    return CircleAvatar(radius: 28, backgroundImage: MemoryImage(bytes));
  }
}
