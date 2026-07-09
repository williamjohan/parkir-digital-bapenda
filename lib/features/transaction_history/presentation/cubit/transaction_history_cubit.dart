import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:parkir_digital_bapenda/core/storage/i_secure_storage_manager.dart';
import 'package:parkir_digital_bapenda/core/utils/app_logger.dart';
import 'package:parkir_digital_bapenda/features/transaction_history/data/models/history_item_model.dart';
import '../../../../core/storage/secure_storage_manager.dart';
import '../../domain/usecases/get_transaction_history_usecase.dart';
import 'transaction_history_state.dart';

@injectable
class TransactionHistoryCubit extends Cubit<TransactionHistoryState> {
  final GetTransactionHistoryUseCase _useCase;
  final ISecureStorageManager _secureStorage;

  static const int _defaultPageSize = 20;
  bool _isFetchingMore = false;

  TransactionHistoryCubit(this._useCase, this._secureStorage)
    : super(TransactionHistoryInitial());

  /// [REMOTE FILTER]: Tembak API Bapenda berdasarkan rentang tanggal
  Future<void> fetchHistory(
    DateTime start,
    DateTime end,
    String nop,
    String idDevice,
  ) async {
    final difference = end.difference(start).inDays.abs();
    if (difference > 30) {
      if (!isClosed) {
        emit(
          const TransactionHistoryError(
            'Rentang waktu maksimal pencarian adalah 30 hari.',
          ),
        );
      }
      return;
    }

    emit(TransactionHistoryLoading());
    _isFetchingMore = false;

    String finalNop = nop;

    if (nop.trim().isEmpty) {
      final profile = await _secureStorage.getJukirProfile() ?? {};
      finalNop = profile['nop']?.toString() ?? '';
    }

    final result = await _useCase.execute(
      startDate: start,
      endDate: end,
      nop: finalNop,
      idDevice: idDevice,
      page: 1,
      pageSize: _defaultPageSize,
    );

    if (isClosed) return;

    result.fold(
      (failure) => emit(TransactionHistoryError(failure.message)),
      (data) => emit(
        TransactionHistoryLoaded(
          allTransactions: data.detail,
          filteredTransactions: data.detail,
          startDate: start,
          endDate: end,
          selectedKategori: 'SEMUA',
          selectedMode: -1,
          roda2: data.roda2,
          roda4: data.roda4,
          totalTransaksi: data.jumlahTransaksi,
          totalPendapatan: data.totalPendapatan,
          totalPajak: data.totalPendapatanBapenda,
          totalBersih: data.totalPendapatanWajibPajak,
          persentasePajak: data.detail.isNotEmpty
              ? data.detail.first.tarifPajak
              : 0,
          nop: finalNop,
          idDevice: idDevice,
          currentPage: 1,
          pageSize: _defaultPageSize,
          hasReachedMax: data.detail.length < _defaultPageSize,
        ),
      ),
    );
  }

  /// [LOCAL FILTER]: Menyortir data yang sudah ada di memori secara instan
  void applyLocalFilter({String? kategori, int? mode}) {
    if (state is! TransactionHistoryLoaded) return;
    final currentState = state as TransactionHistoryLoaded;
    if (!isClosed) {
      emit(_rebuildFilteredState(currentState, kategori: kategori, mode: mode));
    }
  }

  Future<void> loadMoreItems() async {
    if (state is! TransactionHistoryLoaded) return;
    final currentState = state as TransactionHistoryLoaded;

    if (currentState.hasReachedMax || _isFetchingMore) return;

    _isFetchingMore = true;
    emit(currentState.copyWith(isLoadingMore: true));

    final nextPage = currentState.currentPage + 1;

    final result = await _useCase.execute(
      startDate: currentState.startDate,
      endDate: currentState.endDate,
      nop: currentState.nop,
      idDevice: currentState.idDevice,
      page: nextPage,
      pageSize: currentState.pageSize,
    );

    _isFetchingMore = false;
    if (isClosed) return;

    result.fold(
      (failure) {
        AppLogger.error(
          'Gagal load more history (page $nextPage): ${failure.message}',
        );
        if (state is TransactionHistoryLoaded) {
          emit(
            (state as TransactionHistoryLoaded).copyWith(isLoadingMore: false),
          );
        }
      },
      (data) {
        if (state is! TransactionHistoryLoaded) return;
        final latestState = state as TransactionHistoryLoaded;

        final List<HistoryItemModel> newAllTransactions = [
          ...latestState.allTransactions,
          ...data.detail,
        ];

        final updatedBase = latestState.copyWith(
          allTransactions: newAllTransactions,
          currentPage: nextPage,
          hasReachedMax: data.detail.length < latestState.pageSize,
          isLoadingMore: false,
        );

        emit(_rebuildFilteredState(updatedBase));
      },
    );
  }

  TransactionHistoryLoaded _rebuildFilteredState(
    TransactionHistoryLoaded state, {
    String? kategori,
    int? mode,
  }) {
    final newKategori = kategori ?? state.selectedKategori;
    final newMode = mode ?? state.selectedMode;
    final isFiltered = newKategori != 'SEMUA' || newMode != -1;

    final filteredData = state.allTransactions.where((trx) {
      final passKategori = newKategori == 'SEMUA'
          ? true
          : trx.jenisTarif.toUpperCase() == newKategori.toUpperCase();
      final passMode = newMode == -1 ? true : trx.modePlat == newMode;
      return passKategori && passMode;
    }).toList();

    if (!isFiltered) {
      return state.copyWith(
        filteredTransactions: filteredData,
        selectedKategori: newKategori,
        selectedMode: newMode,
      );
    }

    int filterRoda2 = 0;
    int filterRoda4 = 0;
    int filterKotor = 0;
    double filterPajak = 0;
    double filterBersih = 0;

    for (final trx in filteredData) {
      if (trx.jenisTarif == 'MOTOR') filterRoda2++;
      if (trx.jenisTarif == 'MOBIL') filterRoda4++;
      filterKotor += trx.kredit;
      final hitungPajak = (trx.kredit * trx.tarifPajak) / 100;
      filterPajak += hitungPajak;
      filterBersih += (trx.kredit - hitungPajak);
    }

    return state.copyWith(
      filteredTransactions: filteredData,
      selectedKategori: newKategori,
      selectedMode: newMode,
      roda2: filterRoda2,
      roda4: filterRoda4,
      totalTransaksi: filteredData.length,
      totalPendapatan: filterKotor,
      totalPajak: filterPajak,
      totalBersih: filterBersih,
    );
  }
}
