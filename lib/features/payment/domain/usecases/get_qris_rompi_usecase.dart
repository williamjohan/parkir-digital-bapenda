import 'package:injectable/injectable.dart';

import '../entities/qris_rompi_request_entity.dart';
import '../repositories/qris_rompi_repository.dart';

@lazySingleton
class GetQrisRompiUseCase {
  final QrisRompiRepository _repository;

  GetQrisRompiUseCase(this._repository);

  Future<String> call(QrisRompiRequestEntity request) {
    return _repository.getQrisRompi(request);
  }
}
