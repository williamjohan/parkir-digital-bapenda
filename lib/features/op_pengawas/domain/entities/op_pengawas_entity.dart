import 'package:equatable/equatable.dart';
import '../../../../core/enums/app_enums.dart';

class OpPengawasEntity extends Equatable {
  final String uptb;
  final String namaOp;
  final JenisPengawasan jenisPengawasan;
  final String nop;
  final String alamat;

  const OpPengawasEntity({
    required this.uptb,
    required this.namaOp,
    required this.jenisPengawasan,
    required this.nop,
    required this.alamat,
  });

  @override
  List<Object?> get props => [uptb, namaOp, jenisPengawasan, nop, alamat];
}
