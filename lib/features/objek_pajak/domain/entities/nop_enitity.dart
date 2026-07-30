import 'package:equatable/equatable.dart';

class NopEntity extends Equatable {
  final bool isSuccess;
  final int statusCode;
  final String message;
  final NopDataEntity data;

  const NopEntity({
    required this.isSuccess,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  @override
  List<Object?> get props => [isSuccess, statusCode, message, data];
}

class NopDataEntity extends Equatable {
  final String nop;
  final String namaOp;
  final String alamatOp;
  final int uptb;
  final String statusDigitalisasi;

  const NopDataEntity({
    required this.nop,
    required this.namaOp,
    required this.alamatOp,
    required this.uptb,
    required this.statusDigitalisasi,
  });

  @override
  List<Object?> get props => [nop, namaOp, alamatOp, uptb, statusDigitalisasi];
}
