// lib/features/payment/presentation/cubit/payment_state.dart

import 'package:equatable/equatable.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

// State ketika UI harus menggambar QRIS di layar
class PaymentQrisGenerated extends PaymentState {
  final String idTransaksi;
  final String qrisData;
  final int nominal;

  const PaymentQrisGenerated(this.idTransaksi, this.qrisData, this.nominal);

  @override
  List<Object?> get props => [idTransaksi, qrisData, nominal];
}

// State ketika Jukir menekan "OK/Selesai"
class PaymentConfirmed extends PaymentState {}

class PaymentFailure extends PaymentState {
  final String message;

  const PaymentFailure(this.message);

  @override
  List<Object?> get props => [message];
}
