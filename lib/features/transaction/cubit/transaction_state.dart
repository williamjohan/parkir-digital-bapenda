// lib/features/transaction/cubit/transaction_state.dart

import 'package:equatable/equatable.dart';
import '../../home/data/models/tarif_model.dart';
import '../../parking_transaction/data/models/local_transaction_model.dart';

enum TransactionStatus { initial, loading, submitting, success, failure }

class TransactionState extends Equatable {
  final TransactionStatus status;
  final List<TarifModel> tarifList;
  final String nopol;
  final TarifModel? selectedTarif;
  final String? metodePembayaran;
  final bool isFree;
  final String? errorMessage;
  final String? imagePath;
  final LocalTransactionModel? savedTransaction;
  final Map<String, dynamic> jukirProfile;

  const TransactionState({
    this.status = TransactionStatus.initial,
    this.tarifList = const [],
    this.nopol = '',
    this.selectedTarif,
    this.metodePembayaran,
    this.isFree = false,
    this.errorMessage,
    this.imagePath,
    this.savedTransaction,
    this.jukirProfile = const {},
  });

  // Jika Gratis: Cukup pilih kendaraan. Jika Bayar: Wajib kendaraan + metode pembayaran.
  bool get isValid {
    if (isFree) return selectedTarif != null;
    return selectedTarif != null && metodePembayaran != null;
  }

  bool get isTarifEmpty => tarifList.isEmpty;

  TransactionState copyWith({
    TransactionStatus? status,
    List<TarifModel>? tarifList,
    String? nopol,
    TarifModel? selectedTarif,
    String? metodePembayaran,
    bool? isFree,
    String? errorMessage,
    String? imagePath,
    LocalTransactionModel? savedTransaction,
    Map<String, dynamic>? jukirProfile,
  }) {
    return TransactionState(
      status: status ?? this.status,
      tarifList: tarifList ?? this.tarifList,
      nopol: nopol ?? this.nopol,
      selectedTarif: selectedTarif ?? this.selectedTarif,
      metodePembayaran: metodePembayaran ?? this.metodePembayaran,
      isFree: isFree ?? this.isFree,
      errorMessage: errorMessage ?? this.errorMessage,
      imagePath: imagePath ?? this.imagePath,
      savedTransaction: savedTransaction ?? this.savedTransaction,
      jukirProfile: jukirProfile ?? this.jukirProfile,
    );
  }

  @override
  List<Object?> get props => [
    status,
    tarifList,
    nopol,
    selectedTarif,
    metodePembayaran,
    isFree,
    errorMessage,
    imagePath,
    savedTransaction,
    jukirProfile,
  ];
}
