import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
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
        multipartImage = MultipartFileRecreatable.fromFileSync(
          file.path,
          filename: file.path.split('/').last,
        );
      }
    }

    // --- 2. PENANGANAN PLAT NOMOR ---
    String safePlatNumber = transaction.platNomor?.trim() ?? '';
    if (safePlatNumber.isEmpty) {
      safePlatNumber =
          '-'; // Hanya ubah ke strip JIKA memang benar-benar kosong
    }

    // --- 3. PENANGANAN PETUGAS ID ---
    final dynamic rawPetugasId = jukirProfile['idUser'];
    final int safePetugasId = (rawPetugasId is int)
        ? rawPetugasId
        : int.tryParse(rawPetugasId?.toString() ?? '0') ?? 0;
    // --- 3.5. PERBAIKAN FORMAT TANGGAL BAPENDA ---
    String safeDate = transaction.waktuTransaksi;
    try {
      final parsedDate = DateTime.parse(transaction.waktuTransaksi);
      // Memotong ".046488" agar server Bapenda tidak meledak
      safeDate = parsedDate.toIso8601String().split('.').first;
    } catch (_) {}

    // --- 4. RAKIT PAYLOAD ---
    final formData = FormData.fromMap({
      'orderId': transaction.idTransaksiLokal,
      'jenisTarif': transaction.kategoriKendaraan.toUpperCase(),
      'sof': isFree ? 'FREE' : 'QRIS',
      'acquirer': isFree ? 'FREE' : 'BAPENDA',
      'noKartuKUE': isFree ? '-' : (transaction.noKartuKue ?? '-'),
      'noTRX': isFree ? '-' : transaction.idTransaksiLokal,
      'platNumber': safePlatNumber,
      'tglTrx': safeDate,
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

      // 🚀 [BYPASS DICABUT]: Kita kembalikan ke mode normal
      final response = await _dio.post(
        '/api/mobile/parking/insert-transaction',
        data: formData,
      );

      AppLogger.debug('>>> [SYNC SUCCESS] Bapenda membalas: ${response.data}');
    } on DioException catch (e) {
      AppLogger.error('>>> [SYNC ERROR] DioException: ${e.message}');

      // 🚀 [SABUK PENGAMAN]: Jika setelah 3x retry tetap Error (misal 500 lagi),
      // kita tetap bisa melihat alasan penolakannya di terminal tanpa bypass.
      if (e.response != null) {
        AppLogger.error('>>> [RESPONSE BAPENDA]: ${e.response?.data}');
      }

      throw Exception('Gagal Sinkronisasi: ${e.message}');
    }
  }
}
