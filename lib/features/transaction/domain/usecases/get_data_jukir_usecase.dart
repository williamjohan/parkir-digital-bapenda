import 'package:injectable/injectable.dart';
import 'package:parkir_digital_bapenda/features/dashboard_op/data_jukir/domain/entities/data_jukir_entity.dart';
import '../repositories/data_jukir_repository.dart';

@lazySingleton
class GetDataJukirUseCase {
  final DataJukirRepository _repository;

  GetDataJukirUseCase(this._repository);

  Future<List<DataJukirEntity>> call(String nop) {
    return _repository.getDataJukir(nop);
  }
}
