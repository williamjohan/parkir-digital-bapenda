import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:parkir_digital_bapenda/features/objek_pajak/domain/entities/nop_enitity.dart';
import '../../../../core/errors/exception.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/repositories/i_nop_repository.dart';
import '../datasources/nop_remote_datasource.dart';
import '../models/nop/nop_model.dart';

@LazySingleton(as: INopRepository)
class NopRepositoryImpl implements INopRepository {
  final INopRemoteDataSource _nopRemoteDS;

  NopRepositoryImpl(this._nopRemoteDS);

  @override
  Future<Either<Failure, NopEntity>> getNopList() async {
    try {
      final model = await _nopRemoteDS.getNopList();
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Terjadi kesalahan: ${e.toString()}'));
    }
  }
}
