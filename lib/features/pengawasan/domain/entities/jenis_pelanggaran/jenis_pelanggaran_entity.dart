import 'package:equatable/equatable.dart';

import '../../../../../core/enums/app_enums.dart';

class JenisPelanggaranEntity extends Equatable {
  final int id;
  final String namaPelanggaran;
  final JenisPengawasan jenisPelanggaran;

  const JenisPelanggaranEntity({
    required this.id,
    required this.namaPelanggaran,
    required this.jenisPelanggaran,
  });

  @override
  List<Object?> get props => [id, namaPelanggaran, jenisPelanggaran];
}
