// // lib/features/home/domain/usecases/get_hybrid_tarif_usecase.dart

// import 'package:dartz/dartz.dart';
// import 'package:injectable/injectable.dart';
// import '../../../../core/errors/failure.dart';
// import '../../data/models/tarif_model.dart';
// import '../repositories/i_home_repository.dart';

// @lazySingleton
// class GetHybridTarifUseCase {
//   final IHomeRepository repository;

//   GetHybridTarifUseCase(this.repository);

//   Future<Either<Failure, List<TarifModel>>> execute() async {
//     await repository.syncTarif();
//     return repository.getLocalTarifs();
//   }
// }
