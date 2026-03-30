// lib/features/parking_transaction/presentation/cubit/parking_transaction_state.dart

import 'package:equatable/equatable.dart';
import '../../data/models/local_transaction_model.dart';

abstract class ParkingTransactionState extends Equatable {
  const ParkingTransactionState();

  @override
  List<Object?> get props => [];
}

class ParkingTransactionInitial extends ParkingTransactionState {}

class ParkingTransactionLoading extends ParkingTransactionState {}

// [PERBAIKAN ARSITEKTUR]: State ini sekarang membawa "Oleh-oleh" lengkap dari SQLite
class ParkingTransactionSaveSuccess extends ParkingTransactionState {
  final LocalTransactionModel transaction;

  const ParkingTransactionSaveSuccess(this.transaction);

  @override
  List<Object?> get props => [transaction];
}

class ParkingTransactionFailure extends ParkingTransactionState {
  final String message;

  const ParkingTransactionFailure(this.message);

  @override
  List<Object?> get props => [message];
}
