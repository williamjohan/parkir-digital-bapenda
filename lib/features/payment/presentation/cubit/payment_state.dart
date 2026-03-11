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

  const PaymentQrisGenerated(this.idTransaksi, this.qrisData);

  @override
  List<Object?> get props => [idTransaksi, qrisData];
}

// State ketika Jukir menekan "OK/Selesai"
class PaymentConfirmed extends PaymentState {}

class PaymentFailure extends PaymentState {
  final String message;

  const PaymentFailure(this.message);

  @override
  List<Object?> get props => [message];
}
