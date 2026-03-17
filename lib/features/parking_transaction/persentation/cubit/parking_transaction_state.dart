// lib/features/parking_transaction/presentation/cubit/parking_transaction_state.dart

import 'package:equatable/equatable.dart';

abstract class ParkingTransactionState extends Equatable {
  const ParkingTransactionState();

  @override
  List<Object?> get props => [];
}

class ParkingTransactionInitial extends ParkingTransactionState {}

class ParkingTransactionLoading extends ParkingTransactionState {}

// [PERHATIAN]: Saat sukses, State HANYA membawa ID Transaksi!
// Ini yang akan dilempar ke PaymentPage nanti.
class ParkingTransactionSaveSuccess extends ParkingTransactionState {
  final String idTransaksiLokal;

  const ParkingTransactionSaveSuccess(this.idTransaksiLokal);

  @override
  List<Object?> get props => [idTransaksiLokal];
}

class ParkingTransactionFailure extends ParkingTransactionState {
  final String message;

  const ParkingTransactionFailure(this.message);

  @override
  List<Object?> get props => [message];
}
