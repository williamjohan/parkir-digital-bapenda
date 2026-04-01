// lib/features/parking_transaction/data/datasources/parking_transaction_remote_datasource_impl.dart

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/utils/app_logger.dart';
import '../models/local_transaction_model.dart';
import 'i_parking_transaction_remote_datasource.dart';

@LazySingleton(as: IParkingTransactionRemoteDataSource)
class ParkingTransactionRemoteDataSourceImpl
    implements IParkingTransactionRemoteDataSource {
  final Dio _dio;

  ParkingTransactionRemoteDataSourceImpl(this._dio);

  @override
  Future<void> insertTransaction({
    required LocalTransactionModel transaction,
    required Map<String, dynamic> jukirProfile,
  }) async {
    final isFree = transaction.status == 'FREE_OFFLINE';

    // --- 1. PENANGANAN FOTO ---
    MultipartFile? multipartImage;
    if (transaction.fotoKendaraan != null &&
        transaction.fotoKendaraan!.trim().isNotEmpty) {
      final file = File(transaction.fotoKendaraan!);
      if (file.existsSync()) {
        multipartImage = await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        );
      }
    }

    // --- 2. PENANGANAN PLAT NOMOR ---
    String safePlatNumber = transaction.platNomor ?? '';
    if (isFree) {
      safePlatNumber = '-';
    } else if (safePlatNumber.trim().isEmpty) {
      safePlatNumber = '-';
    }

    // --- 3. PENANGANAN PETUGAS ID ---
    final dynamic rawPetugasId = jukirProfile['idUser'];
    final int safePetugasId = (rawPetugasId is int)
        ? rawPetugasId
        : int.tryParse(rawPetugasId?.toString() ?? '0') ?? 0;

    // --- 4. RAKIT PAYLOAD ---
    final formData = FormData.fromMap({
      'orderId': transaction.idTransaksiLokal,

      // [UPDATE 1]: jenisTarif diisi dengan 'MOBIL' atau 'MOTOR' (di-uppercase agar aman untuk BE)
      'jenisTarif': transaction.kategoriKendaraan.toUpperCase(),

      'sof': isFree ? 'FREE' : 'QRIS',
      'acquirer': isFree ? 'FREE' : 'BAPENDA',

      // [UPDATE 2]: noKartuKUE diisi null jika gratis, jika tidak kosongkan string
      'noKartuKUE': isFree ? null : '',

      'noTRX': isFree ? '-' : transaction.idTransaksiLokal,
      'platNumber': isFree ? '-' : safePlatNumber,
      'tglTrx': transaction.waktuTransaksi,
      'kredit': isFree ? 0 : transaction.nominal,
      'saldo': 0,

      'kodeGate': jukirProfile['kodeGate'] ?? '',
      'namaGate': jukirProfile['namaGate'] ?? '',
      'petugasId': safePetugasId,
      'namaPetugas': jukirProfile['namaUser'] ?? '',
      'shift': jukirProfile['shift'] ?? '',
      'lokasiId': jukirProfile['lokasiId'] ?? 0,
      'namaLokasi':
          jukirProfile['namaLokasi'] ?? jukirProfile['namaObjekPajak'] ?? '',
      'deviceId': jukirProfile['idDevice'] ?? '',
      'nop': jukirProfile['nop'] ?? '',

      'latitude': transaction.latitude ?? '0',
      'longitude': transaction.longitude ?? '0',
      'jenisParkir': 'IN',
      'modePlat': transaction.modePlat,
    });

    // --- 5. INJEKSI FOTO ---
    if (multipartImage != null) {
      formData.files.add(MapEntry('fotoNopol', multipartImage));
    }

    // ==========================================================
    // 🔍 [LOG X-RAY] TAMPILKAN PAYLOAD SEBELUM DITEMBAK KE BE
    // ==========================================================
    AppLogger.debug(
      '┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓',
    );
    AppLogger.debug('┃ 🚀 MENGIRIM PAYLOAD KE /insert-transaction');
    AppLogger.debug(
      '┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫',
    );
    AppLogger.debug('┃ [FIELDS / TEKS]:');
    for (var field in formData.fields) {
      AppLogger.debug('┃ 🔑 ${field.key} : ${field.value}');
    }
    AppLogger.debug('┣┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┫');
    AppLogger.debug('┃ [FILES / GAMBAR]:');
    if (formData.files.isEmpty) {
      AppLogger.debug('┃ 📭 Tidak ada file fisik yang dikirim.');
    } else {
      for (var file in formData.files) {
        AppLogger.debug(
          '┃ 📁 ${file.key} : ${file.value.filename} (Size: ${file.value.length} bytes)',
        );
      }
    }
    AppLogger.debug(
      '┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛',
    );
    // ==========================================================

    try {
      AppLogger.debug('>>> [SYNC] Mengeksekusi API POST...');

      final response = await _dio.post(
        '/api/mobile/parking/insert-transaction',
        data: formData,
      );

      if (response.statusCode != 200) {
        throw Exception('Gagal API: ${response.statusCode} - ${response.data}');
      }
    } on DioException catch (e) {
      AppLogger.error('>>> [SYNC ERROR] DioException: ${e.message}');
      throw Exception('Network Error: ${e.message}');
    }
  }
}
