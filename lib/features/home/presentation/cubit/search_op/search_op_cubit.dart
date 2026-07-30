import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/enums/app_enums.dart';
import '../../../../../core/storage/database_helper_2.dart';
import 'search_op_state.dart';

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
          nopList: result, // Simpan sbg Master
          filteredNopList: result, // Tampilkan sbg Default
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> getNopListByKategori({required SearchOpType type}) async {
    emit(state.copyWith(isLoading: true));

    try {
      List<Map<String, dynamic>> result;

      switch (type) {
        case SearchOpType.digital:
          result = await databaseHelper.getNopListByStatusDigitalisasi(
            'Digital',
          );
          break;

        case SearchOpType.nonDigital:
          result = await databaseHelper.getNopListByStatusDigitalisasi(
            'Proses Digital',
          );
          break;

        case SearchOpType.free:
          result = await databaseHelper.getNopListByStatusDigitalisasi(
            'Gratis',
          );
          break;
      }

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

  void searchNopAlamat(String keyword) {
    if (keyword.trim().isEmpty) {
      emit(state.copyWith(filteredNopList: state.nopList));
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

    emit(state.copyWith(filteredNopList: filtered));
  }
}
