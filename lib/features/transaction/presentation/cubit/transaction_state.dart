import 'package:equatable/equatable.dart';
import 'package:parkir_digital_bapenda/features/home/domain/entities/data_jukir_entity.dart';
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

enum DataJukirStatus { initial, loading, success, error }

class TransactionState extends Equatable {
  final TransactionStatus status;
  final DataJukirStatus dataJukirStatus;
  final List<TarifModel> tarifList;
  final List<DataJukirEntity> dataJukirList;
  final TarifModel? selectedTarif;
  final bool isFree;
  final String? errorMessage;

  // Map<jenisKendaraanId, localImagePath> — disimpan dari hasil getLocalQris
  final Map<String, String> qrisMap;

  const TransactionState({
    this.status = TransactionStatus.ready,
    this.dataJukirStatus = DataJukirStatus.initial,
    this.tarifList = const [],
    this.dataJukirList = const [],
    this.selectedTarif,
    this.isFree = false,
    this.errorMessage,
    this.qrisMap = const {},
  });

  bool get isValid => selectedTarif != null;

  bool get isTarifEmpty => tarifList.isEmpty;

  TransactionState copyWith({
    TransactionStatus? status,
    DataJukirStatus? dataJukirStatus,
    List<TarifModel>? tarifList,
    List<DataJukirEntity>? dataJukirList,
    TarifModel? selectedTarif,
    bool clearSelectedTarif = false,
    bool? isFree,
    String? errorMessage,
    Map<String, String>? qrisMap,
  }) {
    return TransactionState(
      status: status ?? this.status,
      dataJukirStatus: dataJukirStatus ?? this.dataJukirStatus,
      tarifList: tarifList ?? this.tarifList,
      dataJukirList: dataJukirList ?? this.dataJukirList,
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
    dataJukirStatus,
    tarifList,
    dataJukirList,
    selectedTarif,
    isFree,
    errorMessage,
    qrisMap,
  ];
}
