import 'package:equatable/equatable.dart';
import '../../domain/entities/detail_tax_surveillance_op_entity.dart';

abstract class DetailTaxSurveillanceState extends Equatable {
  const DetailTaxSurveillanceState();

  @override
  List<Object?> get props => [];
}

class DetailTaxSurveillanceInitial extends DetailTaxSurveillanceState {}

class DetailTaxSurveillanceLoading extends DetailTaxSurveillanceState {}

class TaxSurveillanceLoaded extends DetailTaxSurveillanceState {
  final List<TaxSurveillanceDetailResponseEntity> allItems;
  final List<TaxSurveillanceDetailResponseEntity> filteredItems;
  final String selectedKategori; // 'SEMUA' | 'MOBIL' | 'MOTOR'
  final String nop;
  final DateTime startDate;
  final DateTime endDate;
  final bool isFilterLoading;

  const TaxSurveillanceLoaded({
    required this.allItems,
    required this.filteredItems,
    this.selectedKategori = 'SEMUA',
    required this.nop,
    required this.startDate,
    required this.endDate,
    this.isFilterLoading = false,
  });

  TaxSurveillanceLoaded copyWith({
    List<TaxSurveillanceDetailResponseEntity>? allItems,
    List<TaxSurveillanceDetailResponseEntity>? filteredItems,
    String? selectedKategori,
    String? nop,
    DateTime? startDate,
    DateTime? endDate,
    bool? isFilterLoading,
  }) {
    return TaxSurveillanceLoaded(
      allItems: allItems ?? this.allItems,
      filteredItems: filteredItems ?? this.filteredItems,
      selectedKategori: selectedKategori ?? this.selectedKategori,
      nop: nop ?? this.nop,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isFilterLoading: isFilterLoading ?? this.isFilterLoading,
    );
  }

  @override
  List<Object?> get props => [
    allItems,
    filteredItems,
    selectedKategori,
    nop,
    startDate,
    endDate,
    isFilterLoading,
  ];
}

class TaxSurveillanceError extends DetailTaxSurveillanceState {
  final String message;

  const TaxSurveillanceError(this.message);

  @override
  List<Object> get props => [message];
}
