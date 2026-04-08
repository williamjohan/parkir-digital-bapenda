import 'package:equatable/equatable.dart';

class QrisEntity extends Equatable {
  final String idTransaksi;
  final int nominal;
  final String qrisBase64;
  final String qrBase64;
  final int expTimeMenit;

  const QrisEntity({
    required this.idTransaksi,
    required this.nominal,
    required this.qrisBase64,
    required this.qrBase64,
    required this.expTimeMenit,
  });

  @override
  List<Object?> get props => [
    idTransaksi,
    nominal,
    qrisBase64,
    qrBase64,
    expTimeMenit,
  ];
}
