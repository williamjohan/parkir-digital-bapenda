import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/detail_realisasi_op_entity.dart';

part 'detail_realisasi_op_state.freezed.dart';

@freezed
class DetailRealisasiOpState with _$DetailRealisasiOpState {
  const DetailRealisasiOpState._();

  const factory DetailRealisasiOpState({
    required int selectedYear,
    required int currentYear,
    @Default(false) bool isLoading,
    DetailRealisasiOpEntity? data,
    String? errorMessage,
  }) = _DetailRealisasiOpState;

  bool get canIncrementYear => selectedYear < currentYear;
  bool get canDecrementYear => selectedYear > (currentYear - 1);
}
