import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/op_pengawas_entity.dart';

part 'op_pengawasan_state.freezed.dart';

@freezed
class OpPengawasanState with _$OpPengawasanState {
  const factory OpPengawasanState({
    @Default(false) bool isLoading,
    @Default([]) List<OpPengawasEntity> opPengawasanList,
    @Default([]) List<OpPengawasEntity> filteredOpPengawasanList,
    String? errorMessage,
  }) = _OpPengawasanState;
}
