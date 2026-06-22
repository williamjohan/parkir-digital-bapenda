import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:parkir_digital_bapenda/features/home/presentation/cubit/search_op/search_op_state.dart';

import '../../../../../core/enums/app_enums.dart';
import '../../../../../core/storage/database_helper_2.dart';

@injectable
class SearchOpCubit extends Cubit<SearchOpState> {
  final DatabaseHelper2 databaseHelper;

  SearchOpCubit(this.databaseHelper) : super(const SearchOpState());

  Future<void> getNopList() async {
    emit(state.copyWith(isLoading: true));

    try {
      List<Map<String, dynamic>> result;
      result = await databaseHelper.getNopList();

      emit(state.copyWith(isLoading: false, nopList: result));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  void searchNop(String keyword) {
    if (keyword.trim().isEmpty) {
      emit(state.copyWith(nopList: state.nopList));
      return;
    }

    final filtered = state.nopList.where((item) {
      final nop = (item['nop'] ?? '').toString().toLowerCase();
      final namaLokasi = (item['nama_op'] ?? '').toString().toLowerCase();

      return nop.contains(keyword.toLowerCase()) ||
          namaLokasi.contains(keyword.toLowerCase());
    }).toList();

    emit(state.copyWith(nopList: filtered));
  }

  void searchNopAlamat(String keyword) {
    if (keyword.trim().isEmpty) {
      emit(state.copyWith(nopList: state.nopList));
      return;
    }

    final filtered = state.nopList.where((item) {
      final nop = (item['nop'] ?? '').toString().toLowerCase();
      final namaLokasi = (item['nama_op'] ?? '').toString().toLowerCase();
      final alamatOP = (item['alamat_op'] ?? '').toString().toLowerCase();

      return nop.contains(keyword.toLowerCase()) ||
          namaLokasi.contains(keyword.toLowerCase()) ||
          alamatOP.contains(keyword.toLowerCase());
    }).toList();

    emit(state.copyWith(nopList: filtered));
  }
}
