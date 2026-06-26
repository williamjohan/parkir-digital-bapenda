import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:parkir_digital_bapenda/features/home/domain/entities/data_jukir_entity.dart';
import '../../../home/data/models/tarif_model.dart';

part 'transaction_state.freezed.dart';

enum TransactionStatus { ready, loading, success, submitting, failure }

enum DataJukirStatus { initial, loading, success, error }

@freezed
class TransactionState with _$TransactionState {
  const TransactionState._();

  const factory TransactionState({
    @Default(TransactionStatus.ready) TransactionStatus status,
    @Default([]) List<TarifModel> tarifList,
    TarifModel? selectedTarif,
    @Default(false) bool isFree,
    @Default({}) Map<String, String> qrisMap,
    @Default(DataJukirStatus.initial) DataJukirStatus dataJukirStatus,
    @Default([]) List<DataJukirEntity> dataJukirList,
    DataJukirEntity? selectedJukir,
    String? errorMessage,
  }) = _TransactionState;
  bool isValid(bool requiresJukir) {
    if (requiresJukir) {
      return selectedTarif != null && selectedJukir != null;
    }
    return selectedTarif != null;
  }

  bool get isTarifEmpty => tarifList.isEmpty;
}
