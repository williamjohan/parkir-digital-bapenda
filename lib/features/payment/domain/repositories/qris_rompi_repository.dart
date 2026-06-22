import '../entities/qris_rompi_request_entity.dart';

abstract class QrisRompiRepository {
  Future<String> getQrisRompi(QrisRompiRequestEntity request);
}
