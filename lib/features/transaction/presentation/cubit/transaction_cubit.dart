import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/get_data_jukir_usecase.dart';
import '../../domain/usecases/get_local_qris_usecase.dart';
import 'transaction_state.dart';
import '../../../home/data/models/tarif_model.dart';

// IAppLocationService tidak dipakai lagi di flow QRIS Rompi.
// submitTransaction tidak lagi butuh lokasi — navigasi langsung ke PaymentPage.

@injectable
class TransactionCubit extends Cubit<TransactionState> {
  final GetLocalQrisUseCase _getLocalQrisUseCase;
  final GetDataJukirUseCase _getDataJukirUseCase;

  TransactionCubit(this._getLocalQrisUseCase, this._getDataJukirUseCase)
    : super(const TransactionState());

  // ─── INIT ────────────────────────────────────────────────────────────────────

  Future<void> init(bool isFree) async {
    emit(state.copyWith(status: TransactionStatus.loading, isFree: isFree));

    final result = await _getLocalQrisUseCase.execute();
    if (isClosed) return;

    result.fold((_) => _injectFallbackVehicles(), (qrisMap) {
      if (qrisMap.isEmpty) {
        _injectFallbackVehicles();
      } else {
        _setupVehiclesFromQris(qrisMap);
      }
    });
  }

  // ─── SETUP KENDARAAN ─────────────────────────────────────────────────────────

  void _setupVehiclesFromQris(Map<String, String> qrisMap) {
    final List<TarifModel> vehicles = qrisMap.keys.map((id) {
      return TarifModel(
        id: int.tryParse(id) ?? 0,
        jenisTarif: _labelFromId(id),
        tarif: 0,
      );
    }).toList();

    emit(
      state.copyWith(
        status: TransactionStatus.ready,
        tarifList: vehicles,
        qrisMap: qrisMap,
      ),
    );
  }

  void _injectFallbackVehicles() {
    // qrisMap kosong → PaymentPage akan tampilkan error "QRIS tidak tersedia"
    final List<TarifModel> fallback = [
      const TarifModel(id: 1, jenisTarif: 'Mobil', tarif: 0),
      const TarifModel(id: 2, jenisTarif: 'Motor', tarif: 0),
    ];
    emit(
      state.copyWith(
        status: TransactionStatus.ready,
        tarifList: fallback,
        qrisMap: const {},
      ),
    );
  }

  String _labelFromId(String id) {
    switch (id) {
      case '1':
        return 'Mobil';
      case '2':
        return 'Motor';
      default:
        return 'Kendaraan $id';
    }
  }

  // ─── SELEKSI KENDARAAN ───────────────────────────────────────────────────────

  void selectTarif(TarifModel tarif) {
    emit(state.copyWith(selectedTarif: tarif));
  }

  // ─── SUBMIT → langsung navigasi, tanpa cek lokasi ────────────────────────────

  void proceedToPayment() {
    if (!state.isValid) return;
    // Tidak ada cek lokasi, tidak ada insert transaksi.
    // Cukup sinyal ke UI bahwa validasi lolos → navigasi ke PaymentPage.
    emit(state.copyWith(status: TransactionStatus.success));
  }

  // ─── RESET ───────────────────────────────────────────────────────────────────

  void resetForm() {
    emit(
      state.copyWith(status: TransactionStatus.ready, clearSelectedTarif: true),
    );
  }

  Future<void> getDataJukir(String nop) async {
    emit(state.copyWith(dataJukirStatus: DataJukirStatus.loading));

    try {
      final result = await _getDataJukirUseCase(nop);

      emit(
        state.copyWith(
          dataJukirStatus: DataJukirStatus.success,
          dataJukirList: result,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          dataJukirStatus: DataJukirStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
