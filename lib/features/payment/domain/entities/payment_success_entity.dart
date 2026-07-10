import 'package:equatable/equatable.dart';

class PaymentSuccessEntity extends Equatable {
  final String orderId;
  final String namaOp;
  final String alamatOp;
  final String tanggalTransaksi;
  final String jenisTarif;
  final int credit;
  final String encUrl;

  const PaymentSuccessEntity({
    required this.orderId,
    required this.namaOp,
    required this.alamatOp,
    required this.tanggalTransaksi,
    required this.jenisTarif,
    required this.credit,
    required this.encUrl,
  });

  @override
  List<Object?> get props => [
    orderId,
    namaOp,
    alamatOp,
    tanggalTransaksi,
    jenisTarif,
    credit,
    encUrl,
  ];
}
