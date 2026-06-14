import 'package:equatable/equatable.dart';
import '../../../home/data/models/tarif_model.dart';

enum TransactionStatus {
  ready,
  loading,
  success,
  // Status di bawah tidak lagi dipakai di flow QRIS Rompi.
  // Dipertahankan agar tidak break kode lain yang mungkin masih referensi enum ini.
  // ignore: unused_field
  submitting,
  // ignore: unused_field
  failure,
  // ignore: unused_field
  locationDisabled,
  // ignore: unused_field
  locationPermissionDenied,
}

class TransactionState extends Equatable {
  final TransactionStatus status;
  final List<TarifModel> tarifList;
  final TarifModel? selectedTarif;
  final bool isFree;
  final String? errorMessage;

  // Map<jenisKendaraanId, localImagePath> — disimpan dari hasil getLocalQris
  final Map<String, String> qrisMap;

  const TransactionState({
    this.status = TransactionStatus.ready,
    this.tarifList = const [],
    this.selectedTarif,
    this.isFree = false,
    this.errorMessage,
    this.qrisMap = const {},
  });

  bool get isValid => selectedTarif != null;

  bool get isTarifEmpty => tarifList.isEmpty;

  TransactionState copyWith({
    TransactionStatus? status,
    List<TarifModel>? tarifList,
    TarifModel? selectedTarif,
    bool clearSelectedTarif = false,
    bool? isFree,
    String? errorMessage,
    Map<String, String>? qrisMap,
  }) {
    return TransactionState(
      status: status ?? this.status,
      tarifList: tarifList ?? this.tarifList,
      selectedTarif: clearSelectedTarif
          ? null
          : (selectedTarif ?? this.selectedTarif),
      isFree: isFree ?? this.isFree,
      errorMessage: errorMessage ?? this.errorMessage,
      qrisMap: qrisMap ?? this.qrisMap,
    );
  }

  @override
  List<Object?> get props => [
    status,
    tarifList,
    selectedTarif,
    isFree,
    errorMessage,
    qrisMap,
  ];
}
