// lib/features/parking_transaction/domain/usecases/save_parking_transaction_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exception.dart';
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
    required String jenisTarif,
    required int nominal,
    required int modePlat,
    required String metodePembayaran,
    String? rawImagePath,
  }) async {
    try {
      final location = await locationService.getCurrentLocation();

      return await repository.saveNewTransaction(
        platNomor: platNomor,
        jenisTarif: jenisTarif,
        nominal: nominal,
        modePlat: modePlat,
        metodePembayaran: metodePembayaran,
        rawImagePath: rawImagePath,
        latitude: location['latitude'],
        longitude: location['longitude'],
      );
    } on LocationDisabledException {
      return Left(DatabaseFailure("GPS tidak aktif. Mohon aktifkan lokasi."));
    } on LocationPermissionDeniedException catch (e) {
      final cleanMessage = e.toString().replaceAll('Exception: ', '');
      return Left(DatabaseFailure("Izin lokasi ditolak: $cleanMessage"));
    } catch (e) {
      final cleanMessage = e.toString().replaceAll('Exception: ', '');
      return Left(DatabaseFailure(cleanMessage));
    }
  }
}
