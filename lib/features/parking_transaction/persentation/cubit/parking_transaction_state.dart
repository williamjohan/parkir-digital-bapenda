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

class ParkingTransactionSaveSuccess extends ParkingTransactionState {
  final LocalTransactionModel transaction; // [PENTING]: Membawa seluruh data!

  const ParkingTransactionSaveSuccess(this.transaction);

  @override
  List<Object?> get props => [transaction];
}

class ParkingTransactionUpdateSuccess extends ParkingTransactionState {}

class ParkingTransactionFailure extends ParkingTransactionState {
  final String message;

  const ParkingTransactionFailure(this.message);

  @override
  List<Object?> get props => [message];
}
