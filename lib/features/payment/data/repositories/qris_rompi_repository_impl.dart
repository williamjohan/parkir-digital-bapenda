import 'package:injectable/injectable.dart';
import '../../domain/entities/qris_rompi_request_entity.dart';
import '../../domain/repositories/qris_rompi_repository.dart';
import '../datasources/qris_rompi_datasource.dart';

@LazySingleton(as: QrisRompiRepository)
class QrisRompiRepositoryImpl implements QrisRompiRepository {
  final QrisRompiDatasource _datasource;

  QrisRompiRepositoryImpl(this._datasource);

  @override
  Future<String> getQrisRompi(QrisRompiRequestEntity request) {
    return _datasource.getQrisRompi(request);
  }
}
