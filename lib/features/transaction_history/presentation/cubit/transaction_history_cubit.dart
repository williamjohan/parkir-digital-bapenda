import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:parkir_digital_bapenda/core/storage/i_secure_storage_manager.dart';
import 'package:parkir_digital_bapenda/core/utils/app_logger.dart';
import 'package:parkir_digital_bapenda/features/transaction_history/data/models/history_item_model.dart';
import 'package:parkir_digital_bapenda/features/transaction_history/domain/usecases/get_sof_usecase.dart';
import '../../domain/usecases/get_transaction_history_usecase.dart';
import 'transaction_history_state.dart';

@injectable
class TransactionHistoryCubit extends Cubit<TransactionHistoryState> {
  final GetTransactionHistoryUseCase _useCase;
  final ISecureStorageManager _secureStorage;
  final GetSofBreakdownUseCase _sofUseCase;

  static const int _defaultPageSize = 20;
  bool _isFetchingMore = false;

  TransactionHistoryCubit(this._useCase, this._sofUseCase, this._secureStorage)
    : super(TransactionHistoryInitial());

  int _jenisKendaraanFor(String kategori) {
    switch (kategori) {
      case 'MOBIL':
        return 1;
      case 'MOTOR':
        return 2;
      case 'SEMUA':
      default:
        return 0;
    }
  }

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

    final previousState = state;
    final bool shouldRefreshSof =
        previousState is TransactionHistoryLoaded &&
        previousState.sofDetailList.isNotEmpty;

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
      jenisKendaraan: 0,
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
          sofBreakdown: _computeSofBreakdown(data.detail),
          nop: finalNop,
          idDevice: idDevice,
          currentPage: 1,
          pageSize: _defaultPageSize,
          hasReachedMax: data.detail.length < _defaultPageSize,
          sofDetailList: const [],
          isSofPanelLoading: shouldRefreshSof,
        ),
      ),
    );
    if (shouldRefreshSof) {
      fetchSofBreakdown();
    }
  }

  /// [LOCAL FILTER]: Menyortir data yang sudah ada di memori secara instan
  /// [LOCAL FILTER]: Menyortir data yang sudah ada di memori secara instan
  Future<void> applyFilter({String? kategori, int? mode}) async {
    if (state is! TransactionHistoryLoaded) return;
    final currentState = state as TransactionHistoryLoaded;

    final newKategori = kategori ?? currentState.selectedKategori;
    final newMode = mode ?? currentState.selectedMode;
    final kategoriChanged = newKategori != currentState.selectedKategori;

    // Kategori gak berubah (cuma ganti mode lokal) -> instan, gak nembak API
    if (!kategoriChanged) {
      if (!isClosed) {
        emit(_rebuildFilteredState(currentState, mode: newMode));
      }
      return;
    }

    // 🆕 nyalain skeleton dua-duanya BARENG dari awal
    final bool shouldRefreshSof = currentState.sofDetailList.isNotEmpty;

    emit(
      currentState.copyWith(
        isFilterLoading: true,
        isSofPanelLoading: shouldRefreshSof,
      ),
    );

    // 🆕 dua request ditembak paralel, bukan nunggu satu-satu
    final historyFuture = _useCase.execute(
      startDate: currentState.startDate,
      endDate: currentState.endDate,
      nop: currentState.nop,
      idDevice: currentState.idDevice,
      page: 1,
      pageSize: currentState.pageSize,
      jenisKendaraan: _jenisKendaraanFor(newKategori),
    );

    final sofFuture = shouldRefreshSof
        ? _sofUseCase.execute(
            nop: currentState.nop,
            startDate: currentState.startDate,
            endDate: currentState.endDate,
            jenisKendaraan: _jenisKendaraanFor(newKategori),
          )
        : null;

    // Handle history begitu dia selesai (gak nunggu sof)
    final historyResult = await historyFuture;
    if (isClosed) return;

    final refetched = historyResult.fold<TransactionHistoryLoaded?>(
      (failure) {
        AppLogger.error(
          'Gagal filter kategori $newKategori: ${failure.message}',
        );
        return null;
      },
      (data) => currentState.copyWith(
        allTransactions: data.detail,
        selectedKategori: newKategori,
        roda2: data.roda2,
        roda4: data.roda4,
        totalTransaksi: data.jumlahTransaksi,
        totalPendapatan: data.totalPendapatan,
        totalPajak: data.totalPendapatanBapenda,
        totalBersih: data.totalPendapatanWajibPajak,
        currentPage: 1,
        hasReachedMax: data.detail.length < currentState.pageSize,
        isFilterLoading: false,
      ),
    );

    if (!isClosed) {
      if (refetched == null) {
        if (state is TransactionHistoryLoaded) {
          emit(
            (state as TransactionHistoryLoaded).copyWith(
              isFilterLoading: false,
            ),
          );
        }
      } else {
        emit(_rebuildFilteredState(refetched, mode: newMode));
      }
    }

    // 🆕 handle sof begitu dia selesai — independen, kapanpun dia balik duluan/belakangan
    if (sofFuture != null) {
      final sofResult = await sofFuture;
      if (isClosed) return;

      sofResult.fold(
        (failure) {
          AppLogger.error('Gagal ambil breakdown SOF: ${failure.message}');
          if (state is TransactionHistoryLoaded) {
            emit(
              (state as TransactionHistoryLoaded).copyWith(
                isSofPanelLoading: false,
              ),
            );
          }
        },
        (data) {
          if (state is! TransactionHistoryLoaded) return;
          emit(
            (state as TransactionHistoryLoaded).copyWith(
              sofDetailList: data,
              isSofPanelLoading: false,
            ),
          );
        },
      );
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
      jenisKendaraan: _jenisKendaraanFor(currentState.selectedKategori),
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
    int? mode,
  }) {
    final newMode = mode ?? state.selectedMode;

    if (newMode == -1) {
      return state.copyWith(
        filteredTransactions: state.allTransactions,
        selectedMode: newMode,
        sofBreakdown: _computeSofBreakdown(state.allTransactions),
      );
    }

    final filteredData = state.allTransactions
        .where((trx) => trx.modePlat == newMode)
        .toList();

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
      selectedMode: newMode,
      roda2: filterRoda2,
      roda4: filterRoda4,
      totalTransaksi: filteredData.length,
      totalPendapatan: filterKotor,
      totalPajak: filterPajak,
      totalBersih: filterBersih,
      sofBreakdown: _computeSofBreakdown(filteredData),
    );
  }

  Future<void> fetchSofBreakdown() async {
    if (state is! TransactionHistoryLoaded) return;
    final currentState = state as TransactionHistoryLoaded;

    emit(currentState.copyWith(isSofPanelLoading: true));

    final result = await _sofUseCase.execute(
      nop: currentState.nop,
      startDate: currentState.startDate,
      endDate: currentState.endDate,
      jenisKendaraan: _jenisKendaraanFor(currentState.selectedKategori),
    );

    if (isClosed) return;

    result.fold(
      (failure) {
        AppLogger.error('Gagal ambil breakdown SOF: ${failure.message}');
        if (state is TransactionHistoryLoaded) {
          emit(
            (state as TransactionHistoryLoaded).copyWith(
              isSofPanelLoading: false,
            ),
          );
        }
      },
      (data) {
        if (state is! TransactionHistoryLoaded) return;
        emit(
          (state as TransactionHistoryLoaded).copyWith(
            sofDetailList: data,
            isSofPanelLoading: false,
          ),
        );
      },
    );
  }

  Map<String, int> _computeSofBreakdown(List<HistoryItemModel> data) {
    final Map<String, int> counts = {};
    for (final trx in data) {
      final key = trx.sof.trim().isEmpty ? 'LAINNYA' : trx.sof.toUpperCase();
      counts[key] = (counts[key] ?? 0) + 1;
    }
    return counts;
  }
}
