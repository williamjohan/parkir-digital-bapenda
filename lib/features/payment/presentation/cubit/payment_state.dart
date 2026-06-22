import 'package:equatable/equatable.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentLocalQrisLoading extends PaymentState {}

/// 🚀 STATE 1: Khusus Jukir (Membawa path file SQLite)
class PaymentLocalQrisReady extends PaymentState {
  final String qrisImagePath;
  const PaymentLocalQrisReady(this.qrisImagePath);

  @override
  List<Object?> get props => [qrisImagePath];
}

/// 🚀 STATE 2: Khusus Bapenda Demo (Membawa string mentah QRIS)
class PaymentDemoQrisReady extends PaymentState {
  final String rawQrisString;
  const PaymentDemoQrisReady(this.rawQrisString);

  @override
  List<Object?> get props => [rawQrisString];
}

class PaymentLocalQrisError extends PaymentState {
  final String message;
  const PaymentLocalQrisError(this.message);

  @override
  List<Object?> get props => [message];
}
