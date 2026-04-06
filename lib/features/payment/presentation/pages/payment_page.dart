// lib/features/payment/presentation/pages/payment_page.dart

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:parkir_digital_bapenda/features/payment/presentation/widgets/card_detail_parkir.dart';
import 'package:parkir_digital_bapenda/features/payment/presentation/widgets/card_qris_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saver_gallery/saver_gallery.dart';
import '../../../../core/design_system/components/pb_status_snackbar.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/components/pb_primary_button.dart';
import '../../../../core/storage/secure_storage_manager.dart';
import '../../../../core/design_system/components/pb_ticket_preview_widget.dart';
import '../cubit/payment_cubit.dart';
import '../cubit/payment_state.dart';

// 1. KELAS BUNGKUS ARGUMEN (Boleh bawa platNomor untuk murni ditampilin di UI)
class PaymentPageArgs {
  final String idTransaksiLokal;
  final String kategoriKendaraan;
  final String platNomor;

  PaymentPageArgs({
    required this.idTransaksiLokal,
    required this.kategoriKendaraan,
    required this.platNomor,
  });
}

class PaymentPage extends StatefulWidget {
  final PaymentPageArgs args;

  const PaymentPage({super.key, required this.args});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _secureStorage = locator<ISecureStorageManager>();

  // 🆕 key untuk RepaintBoundary
  final GlobalKey _qrisKey = GlobalKey();

  ////////////////////////////OPTIONAL//////////////////////////////
  Future<bool> _requestPermission() async {
    if (Platform.isAndroid) {
      final deviceInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = deviceInfo.version.sdkInt;

      if (sdkInt >= 33) {
        // Android 13+
        return await Permission.photos.request().isGranted;
      } else {
        return await Permission.storage.request().isGranted;
      }
    } else {
      return await Permission.photosAddOnly.request().isGranted;
    }
  }

  Future<void> _saveQris() async {
    try {
      final isGranted = await _requestPermission();

      if (!isGranted) {
        PbStatusSnackbar.show(context, message: 'Permission ditolak');
        return;
      }

      RenderRepaintBoundary boundary =
          _qrisKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      ui.Image image = await boundary.toImage(pixelRatio: 3.0);

      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData == null) {
        PbStatusSnackbar.show(context, message: 'Gagal ambil gambar');
        return;
      }

      final result = await SaverGallery.saveImage(
        byteData.buffer.asUint8List(),
        fileName: "qris_${DateTime.now().millisecondsSinceEpoch}.png",
        androidRelativePath: "Pictures/QRIS",
        skipIfExists: false,
      );

      PbStatusSnackbar.show(context, message: result.toString());
    } catch (e) {
      PbStatusSnackbar.show(context, message: 'Error: $e');
    }
  }
  ////////////////////////////OPTIONAL//////////////////////////////

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator<PaymentCubit>()
        ..generateQris(
          idTransaksiLokal: widget.args.idTransaksiLokal,
          kategoriKendaraan: widget.args.kategoriKendaraan,
          // Perhatikan: Cubit TETAP TIDAK MEMINTA platNomor! Sangat Clean!
        ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pembayaran QRIS', style: AppTypography.heading3),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: AppColors.textPrimary),
        ),
        body: BlocConsumer<PaymentCubit, PaymentState>(
          listener: (context, state) {
            if (state is PaymentFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.success,
                ),
              );
            } else if (state is PaymentConfirmed) {
              PbStatusSnackbar.show(context, message: 'Pembayaran Berhasil!');
              context.pop(true); // Kembali ke halaman sebelumnya
            }
          },
          builder: (context, state) {
            if (state is PaymentLoading || state is PaymentInitial) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: AppColors.primary),
                    SizedBox(height: 16),
                    Text('Menghasilkan QRIS...', style: AppTypography.bodyText),
                  ],
                ),
              );
            }

            if (state is PaymentQrisGenerated) {
              final profile = state.profile;
              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RepaintBoundary(
                        key: _qrisKey,
                        child: Column(
                          children: [
                            CardQrisWidget(
                              url:
                                  "https://www.google.com/search?q=instagram&oq=&ie=UTF-8",
                              objekPajak:
                                  profile?['namaObjekPajak'] ?? 'Objek Pajak',
                              idTransaksi: state.idTransaksi,
                            ),
                            SizedBox(height: 16),
                            CardDetailParkirWidget(
                              platNomor: widget.args.platNomor,
                              kategoriKendaraan: widget.args.kategoriKendaraan,
                              nominal: state.nominal,
                            ),
                            SizedBox(height: 32),
                            Text(
                              "Diterima di semua e-wallet dan bank",
                              style: AppTypography.caption,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      PbPrimaryButton(
                        text: 'Konfirmasi Pembayaran',
                        onPressed: () async {
                          final profile = await _secureStorage
                              .getJukirProfile();

                          if (!context.mounted) return; // 🔥 WAJIB

                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return Dialog(
                                child: PbPreviewTicketWidget(
                                  deviceId: profile?['idDevice'] ?? '',
                                  orderId: state.idTransaksi,
                                  // orderId: "260131LU3085108",
                                  // deviceId: "086b755cc938a9b6",
                                  objekPajak:
                                      profile?['namaObjekPajak'] ??
                                      'Objek Pajak',
                                  alamatObjekPajak:
                                      profile?['alamat'] ??
                                      'Alamat Objek Pajak',
                                  waktuParkir: DateFormat(
                                    'dd MMM yyyy • HH:mm',
                                    'id_ID',
                                  ).format(DateTime.now()),
                                  tipeKendaraan:
                                      widget.args.kategoriKendaraan == 'motor'
                                      ? 'Motor'
                                      : 'Mobil',
                                  isQuickMode: false,
                                  isFree: profile?['pungutTarif'] == 1,
                                  noKendaraan: widget.args.platNomor,
                                  tarifParkir: state.nominal,
                                  idTransaksi: state.idTransaksi,
                                  okPressed: () {
                                    Navigator.pop(context);
                                    // context.pop(
                                    //   true,
                                    // ); // balik ke halaman sebelumnya
                                  },
                                  printPressed: () {},
                                ),
                              );
                            },
                          );
                        },
                      ),
                      SizedBox(height: 16),
                      PbPrimaryButton(
                        text: 'Simpan QRIS',
                        isOutlined: true,
                        onPressed: () {
                          _saveQris();
                        },
                      ),
                    ],
                  ),
                ),
              );
            }

            return const Center(
              child: Text('Terjadi kesalahan.', style: AppTypography.bodyText),
            );
          },
        ),
      ),
    );
  }
}
