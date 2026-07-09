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
  final int roda2;
  final int roda4;
  final int totalTransaksi;
  final int totalPendapatan;
  final double totalPajak;
  final double totalBersih;
  final int persentasePajak;

  final String nop;
  final String idDevice;
  final int currentPage;
  final int pageSize;
  final bool hasReachedMax;
  final bool isLoadingMore;

  const TransactionHistoryLoaded({
    required this.allTransactions,
    required this.filteredTransactions,
    required this.startDate,
    required this.endDate,
    this.selectedKategori = 'SEMUA',
    this.selectedMode = -1,
    required this.roda2,
    required this.roda4,
    required this.totalTransaksi,
    required this.totalPendapatan,
    required this.totalPajak,
    required this.totalBersih,
    required this.persentasePajak,
    required this.nop,
    required this.idDevice,
    this.currentPage = 1,
    this.pageSize = 20,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
  });

  TransactionHistoryLoaded copyWith({
    List<HistoryItemModel>? allTransactions,
    List<HistoryItemModel>? filteredTransactions,
    DateTime? startDate,
    DateTime? endDate,
    String? selectedKategori,
    int? selectedMode,
    int? roda2,
    int? roda4,
    int? totalTransaksi,
    int? totalPendapatan,
    double? totalPajak,
    double? totalBersih,
    int? persentasePajak,
    String? nop,
    String? idDevice,
    int? currentPage,
    int? pageSize,
    bool? hasReachedMax,
    bool? isLoadingMore,
  }) {
    return TransactionHistoryLoaded(
      allTransactions: allTransactions ?? this.allTransactions,
      filteredTransactions: filteredTransactions ?? this.filteredTransactions,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      selectedKategori: selectedKategori ?? this.selectedKategori,
      selectedMode: selectedMode ?? this.selectedMode,
      roda2: roda2 ?? this.roda2,
      roda4: roda4 ?? this.roda4,
      totalTransaksi: totalTransaksi ?? this.totalTransaksi,
      totalPendapatan: totalPendapatan ?? this.totalPendapatan,
      totalPajak: totalPajak ?? this.totalPajak,
      totalBersih: totalBersih ?? this.totalBersih,
      persentasePajak: persentasePajak ?? this.persentasePajak,
      nop: nop ?? this.nop,
      idDevice: idDevice ?? this.idDevice,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  bool get hasMore => !hasReachedMax;
  List<HistoryItemModel> get visibleTransactions => filteredTransactions;

  @override
  List<Object?> get props => [
    allTransactions,
    filteredTransactions,
    startDate,
    endDate,
    selectedKategori,
    selectedMode,
    roda2,
    roda4,
    totalTransaksi,
    totalPendapatan,
    totalPajak,
    totalBersih,
    persentasePajak,
    nop,
    idDevice,
    currentPage,
    pageSize,
    hasReachedMax,
    isLoadingMore,
  ];
}

class TransactionHistoryError extends TransactionHistoryState {
  final String message;

  const TransactionHistoryError(this.message);

  @override
  List<Object> get props => [message];
}
