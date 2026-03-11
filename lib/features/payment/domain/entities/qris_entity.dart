import 'package:equatable/equatable.dart';

class QrisEntity extends Equatable {
  final String idTransaksi;
  final int nominal;
  final String qrString;

  const QrisEntity({
    required this.idTransaksi,
    required this.nominal,
    required this.qrString,
  });

  @override
  List<Object?> get props => [idTransaksi, nominal, qrString];
}
