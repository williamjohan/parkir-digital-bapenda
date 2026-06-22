import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:parkir_digital_bapenda/features/home/domain/entities/data_jukir_entity.dart';
import '../../domain/usecases/get_data_jukir_usecase.dart';
import '../../domain/usecases/get_local_qris_usecase.dart';
import 'transaction_state.dart';
import '../../../home/data/models/tarif_model.dart';

@injectable
class TransactionCubit extends Cubit<TransactionState> {
  final GetLocalQrisUseCase _getLocalQrisUseCase;
  final GetDataJukirUseCase _getDataJukirUseCase;

  TransactionCubit(this._getLocalQrisUseCase, this._getDataJukirUseCase)
    : super(const TransactionState());

  // ─── INIT (DUAL FLOW ENTRY POINT) ────────────────────────────────────────────

  Future<void> init({required bool isFree, required bool isDemoMode}) async {
    if (!isClosed) {
      emit(state.copyWith(status: TransactionStatus.loading, isFree: isFree));
    }

    // 🚀 JALUR 1: BAPENDA FAB (DEMO MODE)
    // Langsung injeksi data statis, bypass pencarian SQLite
    if (isDemoMode) {
      _injectFallbackVehicles();
      return;
    }

    // 🚀 JALUR 2: JUKIR FAB (LOKAL)
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

  void _setupVehiclesFromQris(Map<String, String> qrisMap) {
    final List<TarifModel> vehicles = qrisMap.keys.map((id) {
      return TarifModel(
        id: int.tryParse(id) ?? 0,
        jenisTarif: _labelFromId(id),
        tarif: 0,
      );
    }).toList();

    if (!isClosed) {
      emit(
        state.copyWith(
          status: TransactionStatus.ready,
          tarifList: vehicles,
          qrisMap: qrisMap,
        ),
      );
    }
  }

  void _injectFallbackVehicles() {
    final List<TarifModel> fallback = [
      const TarifModel(id: 1, jenisTarif: 'Mobil', tarif: 0),
      const TarifModel(id: 2, jenisTarif: 'Motor', tarif: 0),
    ];
    if (!isClosed) {
      emit(
        state.copyWith(
          status: TransactionStatus.ready,
          tarifList: fallback,
          qrisMap: const {},
        ),
      );
    }
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

  void selectTarif(TarifModel tarif) {
    if (!isClosed) emit(state.copyWith(selectedTarif: tarif));
  }

  void proceedToPayment(bool requiresJukir) {
    if (!state.isValid(requiresJukir)) return;
    if (!isClosed) emit(state.copyWith(status: TransactionStatus.success));
  }

  void resetForm() {
    if (!isClosed) {
      emit(
        state.copyWith(status: TransactionStatus.ready, selectedTarif: null),
      );
    }
  }

  // (Legacy function: Tetap ada agar tidak error jika UI memanggilnya,
  // meskipun tidak dipakai karena Search OP dimatikan)
  void selectJukir(DataJukirEntity jukir) {
    if (!isClosed) {
      emit(
        state.copyWith(
          selectedJukir: state.selectedJukir == jukir ? null : jukir,
        ),
      );
    }
  }
}
