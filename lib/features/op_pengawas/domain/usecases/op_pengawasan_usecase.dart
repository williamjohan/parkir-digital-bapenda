import 'package:injectable/injectable.dart';

import '../entities/op_pengawas_entity.dart';
import '../repositories/i_op_pengawasan_repository.dart';

@LazySingleton()
class GetOpPengawasanUseCase {
  final IOpPengawasanRepository repository;

  GetOpPengawasanUseCase(this.repository);

  Future<List<OpPengawasEntity>> call() {
    return repository.getOpPengawasan();
  }
}
