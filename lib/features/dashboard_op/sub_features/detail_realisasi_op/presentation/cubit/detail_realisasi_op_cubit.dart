import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'detail_realisasi_op_state.dart';

@injectable
class RealisasiCubit extends Cubit<RealisasiState> {
  // 🚀 Senjata Rahasia: Timer untuk Debouncing
  Timer? _debounceTimer;

  RealisasiCubit()
    : super(
        RealisasiState(
          // Karena kita hidup di tahun 2026, kita inisialisasi default-nya
          selectedYear: DateTime.now().year,
          currentYear: DateTime.now().year,
        ),
      );

  // ─── FUNGSI TRIGGER DARI UI ──────────────────────────────────────────────────

  void decrementYear() {
    _changeYear(state.selectedYear - 1);
  }

  void incrementYear() {
    if (!state.canIncrementYear) return; // Guard: Cegah lompat ke masa depan
    _changeYear(state.selectedYear + 1);
  }

  void selectYearFromBottomSheet(int year) {
    if (year > state.currentYear) return; // Guard tambahan
    _changeYear(year);
  }

  // ─── LOGIC UTAMA (DEBOUNCING) ────────────────────────────────────────────────

  void _changeYear(int targetYear) {
    // 1. Langsung update UI agar angka tahunnya berubah instan (UX responsif)
    // dan nyalakan mode shimmer/loading
    if (!isClosed) {
      emit(
        state.copyWith(
          selectedYear: targetYear,
          isLoading: true,
          errorMessage: null,
        ),
      );
    }

    // 2. Batalkan hit API sebelumnya (jika Pimpinan masih asyik mencet)
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
      print(
        'DEBUG: Hit API untuk tahun sebelumnya DIBATALKAN. User masih mencet.',
      );
    }

    // 3. Pasang jebakan waktu (Debounce 500ms)
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      print(
        'DEBUG: User berhenti mencet. Mulai FETCH data untuk tahun $targetYear...',
      );
      _fetchDataForYear(targetYear);
    });
  }

  // ─── FETCHING DATA (DUMMY) ───────────────────────────────────────────────────

  Future<void> _fetchDataForYear(int year) async {
    // Guard jika cubit keburu mati saat menunggu timer
    if (isClosed) return;

    try {
      // TODO: Panggil Usecase / Repository di sini
      // final result = await _getRealisasiUseCase(year);

      // Simulasi delay jaringan Bapenda 1 detik
      await Future.delayed(const Duration(seconds: 1));

      if (!isClosed) {
        emit(
          state.copyWith(
            isLoading: false,
            // data: result, // Masukkan hasil mapping
          ),
        );
      }
    } catch (e) {
      if (!isClosed) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage:
                'Gagal mengambil data tahun $year. Silakan coba lagi.',
          ),
        );
      }
    }
  }

  // ─── PEMBERSIHAN MEMORI ──────────────────────────────────────────────────────

  @override
  Future<void> close() {
    // Wajib dimatikan agar tidak ada proses fetch gaib saat halaman ditutup
    _debounceTimer?.cancel();
    return super.close();
  }
}
