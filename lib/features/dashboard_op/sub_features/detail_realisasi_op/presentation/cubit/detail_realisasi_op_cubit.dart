import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'detail_realisasi_op_state.dart';
import '../../domain/repositories/detail_realisasi_op_repository.dart';

@injectable
class DetailRealisasiOpCubit extends Cubit<DetailRealisasiOpState> {
  // 🚀 1. INJEKSI REPOSITORY
  final DetailRealisasiOpRepository _repository;

  Timer? _debounceTimer;
  String _currentNop = ''; // Simpan NOP di memori Cubit

  DetailRealisasiOpCubit(this._repository)
    : super(
        DetailRealisasiOpState(
          selectedYear: DateTime.now().year,
          currentYear: DateTime.now().year,
        ),
      );

  // 🚀 2. ENTRY POINT (Dipanggil dari UI/Router saat halaman pertama kali dibuka)
  void init(String nop) {
    _currentNop = nop;

    // Langsung fetch data tahun berjalan saat halaman terbuka
    if (!isClosed) {
      emit(state.copyWith(isLoading: true, errorMessage: null));
    }
    _fetchDataForYear(state.selectedYear);
  }

  // ─── FUNGSI TRIGGER DARI UI ──────────────────────────────────────────────────

  void decrementYear() {
    _changeYear(state.selectedYear - 1);
  }

  void incrementYear() {
    if (!state.canIncrementYear) return;
    _changeYear(state.selectedYear + 1);
  }

  void selectYearFromBottomSheet(int year) {
    if (year > state.currentYear) return;
    _changeYear(year);
  }

  // ─── LOGIC DEBOUNCING ────────────────────────────────────────────────────────

  void _changeYear(int targetYear) {
    if (!isClosed) {
      // Kosongkan data lama agar UI tidak menampilkan data tahun sebelumnya
      // sambil menunggu API selesai merespons
      emit(
        state.copyWith(
          selectedYear: targetYear,
          isLoading: true,
          errorMessage: null,
          data: null,
        ),
      );
    }

    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _fetchDataForYear(targetYear);
    });
  }

  // ─── FETCHING DATA DARI REPOSITORY ───────────────────────────────────────────

  Future<void> _fetchDataForYear(int year) async {
    if (isClosed) return;
    if (_currentNop.isEmpty) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage:
              'Sistem kehilangan data NOP OP. Silakan kembali ke halaman sebelumnya.',
        ),
      );
      return;
    }

    // 🚀 3. TEMBAK API VIA REPOSITORY
    final result = await _repository.getSummaryRealisasi(
      nop: _currentNop,
      tahun: year,
    );

    if (isClosed) return;

    // 🚀 4. HANDLE RESPONSE (DARTZ EITHER)
    result.fold(
      (failureMessage) {
        emit(state.copyWith(isLoading: false, errorMessage: failureMessage));
      },
      (entityData) {
        emit(state.copyWith(isLoading: false, data: entityData));
      },
    );
  }

  // ─── PEMBERSIHAN MEMORI ──────────────────────────────────────────────────────

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
