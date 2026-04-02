import 'package:equatable/equatable.dart';
import '../../data/models/history_item_model.dart';

abstract class TransactionHistoryState extends Equatable {
  const TransactionHistoryState();

  @override
  List<Object?> get props => [];
}

class TransactionHistoryInitial extends TransactionHistoryState {}

class TransactionHistoryLoading extends TransactionHistoryState {}

class TransactionHistoryLoaded extends TransactionHistoryState {
  // [DATA MASTER]: Data utuh dari API, tidak boleh diubah-ubah
  final List<HistoryItemModel> allTransactions;

  // [DATA TAMPIL]: Data hasil filter yang akan digambar oleh UI
  final List<HistoryItemModel> filteredTransactions;

  // [PARAMETER FILTER]
  final DateTime startDate;
  final DateTime endDate;
  final String selectedKategori; // 'SEMUA', 'MOBIL', 'MOTOR'
  final int selectedMode; // -1 (Semua), 0 (Tanpa Plat), 1 (Pakai Plat)
  final Map<String, dynamic> jukirProfile;

  const TransactionHistoryLoaded({
    required this.allTransactions,
    required this.filteredTransactions,
    required this.startDate,
    required this.endDate,
    this.selectedKategori = 'SEMUA',
    this.selectedMode = -1,
    required this.jukirProfile,
  });

  TransactionHistoryLoaded copyWith({
    List<HistoryItemModel>? allTransactions,
    List<HistoryItemModel>? filteredTransactions,
    DateTime? startDate,
    DateTime? endDate,
    String? selectedKategori,
    int? selectedMode,
    Map<String, dynamic>? jukirProfile,
  }) {
    return TransactionHistoryLoaded(
      allTransactions: allTransactions ?? this.allTransactions,
      filteredTransactions: filteredTransactions ?? this.filteredTransactions,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      selectedKategori: selectedKategori ?? this.selectedKategori,
      selectedMode: selectedMode ?? this.selectedMode,
      jukirProfile: jukirProfile ?? this.jukirProfile,
    );
  }

  @override
  List<Object?> get props => [
    allTransactions,
    filteredTransactions,
    startDate,
    endDate,
    selectedKategori,
    selectedMode,
    jukirProfile,
  ];
}

class TransactionHistoryError extends TransactionHistoryState {
  final String message;

  const TransactionHistoryError(this.message);

  @override
  List<Object> get props => [message];
}
