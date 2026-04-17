// lib/features/transaction/cubit/transaction_state.dart

import 'package:equatable/equatable.dart';
import '../../home/data/models/tarif_model.dart';

enum TransactionStatus {
  ready,
  loading,
  submitting,
  success,
  failure,
  locationDisabled,
}

class TransactionState extends Equatable {
  final TransactionStatus status;
  final List<TarifModel> tarifList;
  final String nopol;
  final TarifModel? selectedTarif;
  final String? metodePembayaran;
  final bool isFree;
  final String? errorMessage;
  final String? imagePath;

  const TransactionState({
    this.status = TransactionStatus.ready,
    this.tarifList = const [],
    this.nopol = '',
    this.selectedTarif,
    this.metodePembayaran,
    this.isFree = false,
    this.errorMessage,
    this.imagePath,
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
    bool clearSelectedTarif = false, // 🚀 Helper untuk mereset ke null
    String? metodePembayaran,
    bool clearMetodePembayaran = false, // 🚀 Helper untuk mereset ke null
    bool? isFree,
    String? errorMessage,
    String? imagePath,
    bool clearImagePath = false, // 🚀 Helper untuk mereset ke null
  }) {
    return TransactionState(
      status: status ?? this.status,
      tarifList: tarifList ?? this.tarifList,
      nopol: nopol ?? this.nopol,
      selectedTarif: clearSelectedTarif
          ? null
          : (selectedTarif ?? this.selectedTarif),
      metodePembayaran: clearMetodePembayaran
          ? null
          : (metodePembayaran ?? this.metodePembayaran),
      isFree: isFree ?? this.isFree,
      errorMessage: errorMessage ?? this.errorMessage,
      imagePath: clearImagePath ? null : (imagePath ?? this.imagePath),
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
  ];
}
