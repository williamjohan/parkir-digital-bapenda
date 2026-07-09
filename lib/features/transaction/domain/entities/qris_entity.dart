import 'package:equatable/equatable.dart';

class QrisResponseEntity extends Equatable {
  final int jenisKendaraanId;
  final String qrisImageBase64;
  final String kodeQris;

  const QrisResponseEntity({
    required this.jenisKendaraanId,
    required this.qrisImageBase64,
    required this.kodeQris,
  });

  @override
  List<Object?> get props => [jenisKendaraanId, qrisImageBase64, kodeQris];
}

class QrisLocalEntity extends Equatable {
  final String path;
  final String kodeQris;

  const QrisLocalEntity({required this.path, required this.kodeQris});

  @override
  List<Object?> get props => [path, kodeQris];
}
