import 'package:equatable/equatable.dart';

class DashboardSummaryJukirEntity extends Equatable {
  final int jumlahMotorHariIni;
  final int jumlahMobilHariIni;
  final double totalNominalHariIni;
  final double totalNominalBersihUntukWajibPajak;
  final double totalNominalBersihUntukBapenda;

  const DashboardSummaryJukirEntity({
    required this.jumlahMotorHariIni,
    required this.jumlahMobilHariIni,
    required this.totalNominalHariIni,
    required this.totalNominalBersihUntukWajibPajak,
    required this.totalNominalBersihUntukBapenda,
  });

  @override
  List<Object?> get props => [
    jumlahMotorHariIni,
    jumlahMobilHariIni,
    totalNominalHariIni,
    totalNominalBersihUntukWajibPajak,
    totalNominalBersihUntukBapenda,
  ];
}
