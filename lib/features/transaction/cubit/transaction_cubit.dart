// lib/features/transaction/cubit/transaction_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../core/storage/secure_storage_manager.dart';
import '../../home/domain/usecases/get_hybrid_tarif_usecase.dart';
import 'transaction_state.dart';
import '../../home/data/models/tarif_model.dart';
import '../../parking_transaction/domain/usecases/save_parking_transaction_usecase.dart';

@injectable
class TransactionCubit extends Cubit<TransactionState> {
  final GetHybridTarifUseCase _getTarifUseCase;
  final SaveParkingTransactionUseCase _saveTransactionUseCase;
  final ISecureStorageManager _secureStorage;

  TransactionCubit(
    this._getTarifUseCase,
    this._saveTransactionUseCase,
    this._secureStorage,
  ) : super(const TransactionState());

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
          // 🚀 Jika data kosong dari Brankas, suntikkan kategori default
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
    emit(state.copyWith(nopol: value.toUpperCase(), imagePath: null));
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

  Future<void> submitTransaction() async {
    if (!state.isValid) return;

    emit(state.copyWith(status: TransactionStatus.submitting));

    final int modePlat = state.nopol.trim().isNotEmpty ? 1 : 0;
    final String? finalPlat = state.nopol.trim().isEmpty
        ? null
        : state.nopol.trim();

    final String finalJenisTarif =
        state.selectedTarif?.jenisTarif ?? 'Objek Pajak Gratis';
    final int finalNominal = state.selectedTarif?.tarif.toInt() ?? 0;
    final String finalSof = state.isFree
        ? 'FREE'
        : (state.metodePembayaran ?? 'UNKNOWN');

    final result = await _saveTransactionUseCase.execute(
      platNomor: finalPlat,
      jenisTarif: finalJenisTarif,
      nominal: finalNominal,
      metodePembayaran: finalSof,
      modePlat: modePlat,
      rawImagePath: state.imagePath,
    );
    if (isClosed) return;

    await result.fold(
      (failure) async => emit(
        state.copyWith(
          status: TransactionStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (transactionResult) async {
        final profile = await _secureStorage.getJukirProfile() ?? {};

        emit(
          state.copyWith(
            status: TransactionStatus.success,
            savedTransaction: transactionResult,
            jukirProfile: profile,
          ),
        );
      },
    );
  }
}
