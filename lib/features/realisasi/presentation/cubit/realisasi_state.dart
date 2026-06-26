import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/realisasi_entity.dart';

part 'realisasi_state.freezed.dart';

@freezed
class RealisasiState with _$RealisasiState {
  const RealisasiState._();

  const factory RealisasiState({
    required int selectedYear,
    required int currentYear,
    @Default(false) bool isLoading,
    @Default([]) List<RealisasiEntity> data,
    String? errorMessage,
  }) = _RealisasiState;
  bool get canIncrementYear => selectedYear < currentYear;
  bool get canDecrementYear =>
      selectedYear > (currentYear - 2); // Misal mundur max 2 tahun

  double get totalTarget {
    if (data.isEmpty) return 0.0;
    return data.fold(0.0, (sum, item) => sum + item.akpTarget);
  }

  double get totalRealisasi {
    if (data.isEmpty) return 0.0;
    return data.fold(0.0, (sum, item) => sum + item.realisasi);
  }

  double get totalSelisih {
    if (data.isEmpty) return 0.0;
    return data.fold(0.0, (sum, item) => sum + item.selisih);
  }

  double get totalPencapaianPersen {
    if (totalTarget == 0.0) return 0.0;
    return (totalRealisasi / totalTarget) * 100;
  }
}
