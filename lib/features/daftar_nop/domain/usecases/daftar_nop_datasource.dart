import 'package:injectable/injectable.dart';

import '../entities/daftar_nop_entity.dart';
import '../repositories/daftar_nop_repository.dart';

@lazySingleton
class GetDaftarNopUsecase {
  final DaftarNopRepository repository;

  GetDaftarNopUsecase(this.repository);

  Future<List<DaftarNopEntity>> call() {
    return repository.getDaftarNop();
  }
}
