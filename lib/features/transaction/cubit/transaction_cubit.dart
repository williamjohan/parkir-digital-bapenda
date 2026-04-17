// lib/features/transaction/cubit/transaction_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../core/errors/exception.dart';
import '../../../core/services/location/i_app_location_service.dart';
import '../../home/domain/usecases/get_hybrid_tarif_usecase.dart';
import 'transaction_state.dart';
import '../../home/data/models/tarif_model.dart';

@injectable
class TransactionCubit extends Cubit<TransactionState> {
  final GetHybridTarifUseCase _getTarifUseCase;
  final IAppLocationService _locationService;

  TransactionCubit(this._getTarifUseCase, this._locationService)
    : super(const TransactionState());

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

  Future<void> submitTransaction() async {
    if (!state.isValid) return;

    // Trigger animasi loading di tombol
    emit(state.copyWith(status: TransactionStatus.submitting));

    try {
      final location = await _locationService.getCurrentLocation();

      if (isClosed) return;

      emit(
        state.copyWith(
          status: TransactionStatus.success,
          latitude: location['latitude'],
          longitude: location['longitude'],
        ),
      );
    } on LocationDisabledException {
      if (isClosed) return;
      emit(state.copyWith(status: TransactionStatus.locationDisabled));
    } on LocationPermissionDeniedException catch (e) {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: TransactionStatus.locationPermissionDenied,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: TransactionStatus.failure,
          errorMessage: "Gagal mendapatkan lokasi.",
        ),
      );
    }
  }

  void resetForm() {
    emit(
      TransactionState(
        status: TransactionStatus.ready,
        tarifList: state.tarifList,
        isFree: state.isFree,
        nopol: '',
        selectedTarif: null,
        metodePembayaran: null,
        imagePath: null,
      ),
    );
  }
}
