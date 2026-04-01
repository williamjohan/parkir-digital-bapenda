// lib/features/parking_transaction/domain/usecases/save_parking_transaction_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/services/location/i_app_location_service.dart'; // [TAMBAHAN]
import '../../data/models/local_transaction_model.dart';
import '../repositories/i_parking_transaction_repository.dart';

@lazySingleton
class SaveParkingTransactionUseCase {
  final IParkingTransactionRepository repository;
  final IAppLocationService locationService; // [TAMBAHAN]: Injeksi Sensor GPS

  SaveParkingTransactionUseCase(this.repository, this.locationService);

  Future<Either<Failure, LocalTransactionModel>> execute({
    String? platNomor,
    required String kategoriKendaraan,
    String? rawImagePath,
    required int modePlat,
  }) async {
    // [PERBAIKAN]: Tambahkan async

    // 1. Ambil koordinat GPS real-time (Maksimal 3 detik atau fallback)
    final location = await locationService.getCurrentLocation();
    final latitude = location['latitude'];
    final longitude = location['longitude'];

    // 2. Lempar seluruh data (termasuk GPS) ke Repository
    return repository.saveNewTransaction(
      platNomor: platNomor,
      kategoriKendaraan: kategoriKendaraan,
      rawImagePath: rawImagePath,
      modePlat: modePlat,
      latitude: latitude, // [TAMBAHAN]
      longitude: longitude, // [TAMBAHAN]
    );
  }
}
