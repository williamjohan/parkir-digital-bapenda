import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import '../../domain/entities/qris_entity.dart';
import '../../../parking_transaction/data/models/local_transaction_model.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

class PaymentCheckLoading extends PaymentState {}

// 🚀 Sinyal untuk memunculkan Snackbar Info
class PaymentPendingInfo extends PaymentState {
  final String message;
  const PaymentPendingInfo(this.message);

  @override
  List<Object?> get props => [message];
}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentQrisReady extends PaymentState {
  final QrisEntity qris;
  final Uint8List qrisBytes;

  const PaymentQrisReady(this.qris, this.qrisBytes);

  @override
  List<Object?> get props => [qris, qrisBytes];
}

class PaymentSyncing extends PaymentState {}

class PaymentSuccess extends PaymentState {
  final String message;
  final LocalTransactionModel transaction;

  const PaymentSuccess(this.message, this.transaction);

  @override
  List<Object?> get props => [message, transaction];
}

class PaymentError extends PaymentState {
  final String message;
  const PaymentError(this.message);

  @override
  List<Object?> get props => [message];
}

class PaymentTimeout extends PaymentState {
  final String message;
  const PaymentTimeout(this.message);

  @override
  List<Object?> get props => [message];
}
