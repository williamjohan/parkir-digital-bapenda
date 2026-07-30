import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:parkir_digital_bapenda/features/dashboard_op/detail_tax_surveillance_op/domain/usecases/detail_tax_surveillance_op_repository_usecase.dart';
import 'package:parkir_digital_bapenda/features/dashboard_op/detail_tax_surveillance_op/presentation/cubit/detail_tax_surveillance_state.dart';
import '../../../../../core/utils/app_logger.dart';
import '../../domain/entities/detail_tax_surveillance_op_entity.dart';

@injectable
class DetailTaxSurveillanceCubit extends Cubit<DetailTaxSurveillanceState> {
  final TaxSurveillanceUseCase _useCase;

  DetailTaxSurveillanceCubit(this._useCase) : super(DetailTaxSurveillanceInitial());

  bool _matchesKategori(
    TaxSurveillanceDetailResponseEntity item,
    String kategori,
  ) {
    return item.jenisKendaraan.toUpperCase() == kategori;
  }

  List<TaxSurveillanceDetailResponseEntity> _applyLocalFilter(
    List<TaxSurveillanceDetailResponseEntity> items,
    String kategori,
  ) {
    if (kategori == 'SEMUA') return items;
    return items.where((item) => _matchesKategori(item, kategori)).toList();
  }

  /// [REMOTE - DEFAULT]: Load data hari ini, dipanggil pas screen pertama dibuka
  Future<void> fetchDefault(String nop) async {
    emit(DetailTaxSurveillanceLoading());

    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = DateTime(now.year, now.month, now.day, 23, 59, 59);

    final result = await _useCase.getDefaultDetail(nop);

    if (isClosed) return;

    result.fold(
      (failure) {
        AppLogger.error(
          'Gagal ambil default tax surveillance: ${failure.message}',
        );
        emit(TaxSurveillanceError(failure.message));
      },
      (data) => emit(
        TaxSurveillanceLoaded(
          allItems: data,
          filteredItems: data,
          selectedKategori: 'SEMUA',
          nop: nop,
          startDate: start,
          endDate: end,
        ),
      ),
    );
  }

  /// [REMOTE - FILTER TANGGAL]: Tembak API berdasarkan rentang tanggal dari RangeFilterWidget
  Future<void> fetchFiltered(String nop, DateTime start, DateTime end) async {
    // Pertahankan kategori yang lagi aktif (kalau ada) biar gak balik ke SEMUA
    // pas user cuma ganti tanggal.
    final previousState = state;
    final activeKategori = previousState is TaxSurveillanceLoaded
        ? previousState.selectedKategori
        : 'SEMUA';

    emit(DetailTaxSurveillanceLoading());

    final result = await _useCase.getFilteredDetail(
      TaxSurveillanceRequestEntity(nop: nop, startDate: start, endDate: end),
    );

    if (isClosed) return;

    result.fold(
      (failure) {
        AppLogger.error('Gagal filter tax surveillance: ${failure.message}');
        emit(TaxSurveillanceError(failure.message));
      },
      (data) => emit(
        TaxSurveillanceLoaded(
          allItems: data,
          filteredItems: _applyLocalFilter(data, activeKategori),
          selectedKategori: activeKategori,
          nop: nop,
          startDate: start,
          endDate: end,
        ),
      ),
    );
  }

  /// [LOCAL FILTER]: Filter kategori SEMUA/MOBIL/MOTOR — instan, gak nembak API,
  /// soalnya jenisKendaraan gak ada di kontrak request backend.
  void applyFilter(String kategori) {
    final currentState = state;
    if (currentState is! TaxSurveillanceLoaded) return;

    emit(
      currentState.copyWith(
        selectedKategori: kategori,
        filteredItems: _applyLocalFilter(currentState.allItems, kategori),
      ),
    );
  }
}
