import 'dart:io';
import 'package:injectable/injectable.dart';
import '../entities/pengawasan_entity.dart';
import '../repositories/i_pengawasan_repository.dart';

@LazySingleton()
class AddPengawasanUsecase {
  final PengawasanRepository _repository;

  AddPengawasanUsecase(this._repository);

  Future<void> call(PengawasanEntity entity, File buktiFoto) {
    return _repository.addPengawasan(entity, buktiFoto);
  }
}
