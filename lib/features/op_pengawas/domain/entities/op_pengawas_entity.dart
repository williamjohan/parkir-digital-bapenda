import 'package:equatable/equatable.dart';
import '../../../../core/enums/app_enums.dart';

class OpPengawasEntity extends Equatable {
  final String kecamatan;
  final String namaOp;
  final JenisPengawasan jenisPengawasan;
  final String nop;
  final String alamat;

  const OpPengawasEntity({
    required this.kecamatan,
    required this.namaOp,
    required this.jenisPengawasan,
    required this.nop,
    required this.alamat,
  });

  @override
  List<Object?> get props => [kecamatan, namaOp, jenisPengawasan, nop, alamat];
}
