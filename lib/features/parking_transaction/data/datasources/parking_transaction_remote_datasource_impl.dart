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
  final Dio
  _dio; // Pastikan Dio sudah ter-inject dengan BaseOptions & Interceptor Auth Anda

  ParkingTransactionRemoteDataSourceImpl(this._dio);

  @override
  Future<void> insertTransaction({
    required LocalTransactionModel transaction,
    required Map<String, dynamic> jukirProfile,
  }) async {
    // 1. Evaluasi Status Gratis/Berbayar
    final isFree = transaction.status == 'FREE_OFFLINE';

    // 2. Siapkan File Gambar (Jika Ada)
    MultipartFile? multipartImage;
    if (transaction.fotoKendaraan != null &&
        transaction.fotoKendaraan!.isNotEmpty) {
      final file = File(transaction.fotoKendaraan!);
      if (file.existsSync()) {
        multipartImage = await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        );
      }
    }

    // 3. Rakit Payload sesuai kesepakatan Bapenda
    final formData = FormData.fromMap({
      'orderId': transaction.idTransaksiLokal,
      'jenisTarif': isFree
          ? 'FREE'
          : 'NORMAL', // Sesuaikan jika BE minta kode angka
      'sof': isFree ? 'FREE' : 'QRIS', // Sesuai kesepakatan
      'acquirer': isFree ? 'FREE' : 'BAPENDA',
      'noKartuKUE': isFree ? 'FREE' : '', // Bisa null/kosong
      'noTRX': transaction
          .idTransaksiLokal, // Gunakan orderId sebagai noTRX sementara
      'platNumber': transaction.platNomor ?? '',
      'tglTrx': transaction.waktuTransaksi,
      'kredit': isFree ? 0 : transaction.nominal,
      'saldo': 0,

      // Ambil dari Profile Jukir
      'kodeGate': jukirProfile['kodeGate'] ?? '',
      'namaGate': jukirProfile['namaGate'] ?? '',
      'petugasId': jukirProfile['idUser'] ?? '',
      'namaPetugas': jukirProfile['namaUser'] ?? '',
      'shift': jukirProfile['shift'] ?? '',
      'lokasiId': jukirProfile['lokasiId'] ?? 0,
      'namaLokasi': jukirProfile['namaObjekPajak'] ?? '', // Sesuai kesepakatan
      'deviceId': jukirProfile['idDevice'] ?? '',
      'nop': jukirProfile['nop'] ?? '',

      // GPS & Konfigurasi Ekstra
      'latitude': transaction.latitude ?? '0',
      'longitude': transaction.longitude ?? '0',
      'jenisParkir': 'IN', // Asumsi default
      'modePlat': transaction.modePlat,
    });

    // Masukkan gambar secara terpisah ke FormData jika ada
    if (multipartImage != null) {
      formData.files.add(MapEntry('fotoNopol', multipartImage));
    }

    try {
      AppLogger.debug(
        '>>> [SYNC] Mengirim Transaksi: ${transaction.idTransaksiLokal}',
      );

      // 4. Tembak API!
      final response = await _dio.post(
        '/api/mobile/parking/insert-transaction', // Sesuaikan dengan endpoint Anda
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
