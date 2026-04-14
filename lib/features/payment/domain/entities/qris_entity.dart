import 'package:equatable/equatable.dart';

class QrisEntity extends Equatable {
  final String kodeQris;
  final String qrisValue;
  final String qrisBase64;
  final String nmid;
  final String nameQris;
  final int nominal;
  final int expTimeMenit;

  const QrisEntity({
    required this.kodeQris,
    required this.qrisValue,
    required this.qrisBase64,
    required this.nmid,
    required this.nameQris,
    required this.nominal,
    required this.expTimeMenit,
  });

  @override
  List<Object?> get props => [kodeQris, nmid, nominal];
}
