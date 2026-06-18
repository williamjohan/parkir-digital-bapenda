import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:parkir_digital_bapenda/features/home/presentation/cubit/search_op/search_op_state.dart';

import '../../../../../core/storage/database_helper_2.dart';

@injectable
class SearchOpCubit extends Cubit<SearchOpState> {
  final DatabaseHelper2 databaseHelper;

  SearchOpCubit(this.databaseHelper) : super(const SearchOpState());

  Future<void> getNopList() async {
    emit(state.copyWith(isLoading: true));

    try {
      final result = await databaseHelper.getNopList();

      emit(
        state.copyWith(
          isLoading: false,
          nopList: result,
          filteredNopList: result,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  void searchNop(String keyword) {
    if (keyword.trim().isEmpty) {
      emit(state.copyWith(filteredNopList: state.nopList));
      return;
    }

    final filtered = state.nopList.where((item) {
      final nop = (item['nop'] ?? '').toString().toLowerCase();
      final namaLokasi = (item['nama_op'] ?? '').toString().toLowerCase();

      return nop.contains(keyword.toLowerCase()) ||
          namaLokasi.contains(keyword.toLowerCase());
    }).toList();

    emit(state.copyWith(filteredNopList: filtered));
  }
}
