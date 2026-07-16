import 'package:equatable/equatable.dart';

// --- ENTITY UNTUK RESPONSE (INCOMING) ---
class TaxSurveillanceDetailResponseEntity extends Equatable {
  final String jenisKendaraan;
  final int nominal;
  final DateTime tgl;

  const TaxSurveillanceDetailResponseEntity({
    required this.jenisKendaraan,
    required this.nominal,
    required this.tgl,
  });

  @override
  List<Object> get props => [jenisKendaraan, nominal, tgl];
}

// --- ENTITY UNTUK REQUEST / FILTER (OUTGOING) ---
class TaxSurveillanceRequestEntity extends Equatable {
  final String nop;
  final DateTime startDate;
  final DateTime endDate;

  const TaxSurveillanceRequestEntity({
    required this.nop,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object> get props => [nop, startDate, endDate];
}
