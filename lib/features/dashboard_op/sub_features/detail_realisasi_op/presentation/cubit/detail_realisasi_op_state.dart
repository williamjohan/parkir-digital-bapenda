import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/detail_realisasi_op_entity.dart';

part 'detail_realisasi_op_state.freezed.dart';

@freezed
class RealisasiState with _$RealisasiState {
  const RealisasiState._();

  const factory RealisasiState({
    required int selectedYear,
    required int currentYear,
    @Default(false) bool isLoading,
    RealisasiTahunEntity? data,
    String? errorMessage,
  }) = _RealisasiState;

  // 🚀 Helper Cerdas untuk UI: Mengecek apakah panah kanan boleh ditekan
  bool get canIncrementYear => selectedYear < currentYear;
}
