import 'package:equatable/equatable.dart';
import '../../domain/entities/qris_entity.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentQrisReady extends PaymentState {
  final QrisEntity qris;
  const PaymentQrisReady(this.qris);

  @override
  List<Object?> get props => [qris];
}

class PaymentSuccess extends PaymentState {
  final String message;
  const PaymentSuccess(this.message);

  @override
  List<Object?> get props => [message];
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
