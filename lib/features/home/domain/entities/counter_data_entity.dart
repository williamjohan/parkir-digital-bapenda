import 'package:equatable/equatable.dart';

class CounterDataEntity extends Equatable {
  final int jumlahMotor;
  final int jumlahMobil;

  const CounterDataEntity({
    required this.jumlahMotor,
    required this.jumlahMobil,
  });

  @override
  List<Object?> get props => [jumlahMotor, jumlahMobil];
}