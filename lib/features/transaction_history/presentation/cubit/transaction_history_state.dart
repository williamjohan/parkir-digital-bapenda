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
  final List<HistoryItemModel> allTransactions;
  final List<HistoryItemModel> filteredTransactions;

  final DateTime startDate;
  final DateTime endDate;
  final String selectedKategori;
  final int selectedMode;
  final Map<String, dynamic> jukirProfile;

  // ✅ TAMBAHAN
  final int roda2;
  final int roda4;
  final int totalTransaksi;
  final int totalPendapatan;

  const TransactionHistoryLoaded({
    required this.allTransactions,
    required this.filteredTransactions,
    required this.startDate,
    required this.endDate,
    this.selectedKategori = 'SEMUA',
    this.selectedMode = -1,
    required this.jukirProfile,

    // ✅ wajib diisi
    required this.roda2,
    required this.roda4,
    required this.totalTransaksi,
    required this.totalPendapatan,
  });

  TransactionHistoryLoaded copyWith({
    List<HistoryItemModel>? allTransactions,
    List<HistoryItemModel>? filteredTransactions,
    DateTime? startDate,
    DateTime? endDate,
    String? selectedKategori,
    int? selectedMode,
    Map<String, dynamic>? jukirProfile,

    // ✅ tambahan
    int? roda2,
    int? roda4,
    int? totalTransaksi,
    int? totalPendapatan,
  }) {
    return TransactionHistoryLoaded(
      allTransactions: allTransactions ?? this.allTransactions,
      filteredTransactions: filteredTransactions ?? this.filteredTransactions,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      selectedKategori: selectedKategori ?? this.selectedKategori,
      selectedMode: selectedMode ?? this.selectedMode,
      jukirProfile: jukirProfile ?? this.jukirProfile,

      roda2: roda2 ?? this.roda2,
      roda4: roda4 ?? this.roda4,
      totalTransaksi: totalTransaksi ?? this.totalTransaksi,
      totalPendapatan: totalPendapatan ?? this.totalPendapatan,
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
    roda2,
    roda4,
    totalTransaksi,
    totalPendapatan,
  ];
}

class TransactionHistoryError extends TransactionHistoryState {
  final String message;

  const TransactionHistoryError(this.message);

  @override
  List<Object> get props => [message];
}
