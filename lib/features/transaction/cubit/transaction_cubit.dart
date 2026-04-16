// lib/features/transaction/cubit/transaction_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../home/domain/usecases/get_hybrid_tarif_usecase.dart';
import 'transaction_state.dart';
import '../../home/data/models/tarif_model.dart';

@injectable
class TransactionCubit extends Cubit<TransactionState> {
  final GetHybridTarifUseCase _getTarifUseCase;

  TransactionCubit(this._getTarifUseCase) : super(const TransactionState());

  Future<void> init(bool isFree) async {
    emit(state.copyWith(status: TransactionStatus.loading, isFree: isFree));

    final result = await _getTarifUseCase.execute();
    if (isClosed) return;

    result.fold(
      (failure) {
        if (isFree) {
          _injectFreeTariff();
        } else {
          emit(
            state.copyWith(
              status: TransactionStatus.failure,
              errorMessage: failure.message,
            ),
          );
        }
      },
      (data) {
        if (data.isEmpty && isFree) {
          // Jika data kosong dari Brankas, suntikkan kategori default
          _injectFreeTariff();
        } else {
          emit(
            state.copyWith(status: TransactionStatus.ready, tarifList: data),
          );
        }
      },
    );
  }

  void _injectFreeTariff() {
    final List<TarifModel> dummyFree = [
      const TarifModel(id: -1, jenisTarif: 'Motor', tarif: 0),
      const TarifModel(id: -2, jenisTarif: 'Mobil', tarif: 0),
    ];
    emit(state.copyWith(status: TransactionStatus.ready, tarifList: dummyFree));
  }

  void updateNopol(String value) {
    emit(state.copyWith(nopol: value.toUpperCase(), clearImagePath: true));
  }

  void updateFromOcr(String platNomor, String imagePath) {
    emit(state.copyWith(nopol: platNomor.toUpperCase(), imagePath: imagePath));
  }

  void selectTarif(TarifModel tarif) {
    emit(state.copyWith(selectedTarif: tarif));
  }

  void selectPayment(String method) {
    emit(state.copyWith(metodePembayaran: method));
  }

  /// 🚀 FUNGSI BARU: VALIDATOR MURNI
  Future<void> submitTransaction() async {
    if (!state.isValid) return;

    // Ubah ke submitting (trigger animasi loading sebentar di tombol)
    emit(state.copyWith(status: TransactionStatus.submitting));

    // Jeda sedikit agar transisi UI terlihat halus & natural
    await Future.delayed(const Duration(milliseconds: 300));

    if (isClosed) return;

    // Lampu hijau! Lemparkan status success ke UI agar UI yang berpindah halaman
    emit(state.copyWith(status: TransactionStatus.success));
  }

  /// 🚀 FUNGSI BARU: RESET FORM SETELAH KEMBALI DARI HALAMAN QRIS
  void resetForm() {
    // Kita buat ulang state, TAPI pertahankan list tarif & isFree agar tidak perlu fetch API ulang
    emit(
      TransactionState(
        status: TransactionStatus.ready,
        tarifList: state.tarifList,
        isFree: state.isFree,
        nopol: '', // Kosongkan
        selectedTarif: null, // Kosongkan
        metodePembayaran: null, // Kosongkan
        imagePath: null,
      ),
    );
  }
}
