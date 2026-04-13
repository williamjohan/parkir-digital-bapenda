// lib/features/parking_transaction/domain/usecases/save_parking_transaction_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/services/location/i_app_location_service.dart';
import '../../data/models/local_transaction_model.dart';
import '../repositories/i_parking_transaction_repository.dart';

@lazySingleton
class SaveParkingTransactionUseCase {
  final IParkingTransactionRepository repository;
  final IAppLocationService locationService;

  SaveParkingTransactionUseCase(this.repository, this.locationService);

  Future<Either<Failure, LocalTransactionModel>> execute({
    String? platNomor,
    required String jenisTarif, // Kirim teks "Motor"/"Mobil" sesuai Swagger
    required int nominal,
    required int modePlat, // Kirim harga (kredit)
    required String metodePembayaran, // Untuk mapping ke 'sof' di Swagger
    String? rawImagePath,
  }) async {
    // Ambil GPS real-time
    final location = await locationService.getCurrentLocation();

    return repository.saveNewTransaction(
      platNomor: platNomor,
      jenisTarif: jenisTarif,
      nominal: nominal,
      modePlat: modePlat,
      metodePembayaran: metodePembayaran,
      rawImagePath: rawImagePath,
      latitude: location['latitude'],
      longitude: location['longitude'],
    );
  }
}
