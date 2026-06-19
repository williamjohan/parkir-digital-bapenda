import 'package:equatable/equatable.dart';

import '../../../../../core/enums/app_enums.dart';

class SearchOpState extends Equatable {
  final bool isLoading;
  final List<Map<String, dynamic>> nopList;
  final List<Map<String, dynamic>> filteredNopList;
  final String? errorMessage;

  final SearchOpType selectedType;

  const SearchOpState({
    this.isLoading = false,
    this.nopList = const [],
    this.filteredNopList = const [],
    this.selectedType = SearchOpType.digital,
    this.errorMessage,
  });

  SearchOpState copyWith({
    bool? isLoading,
    List<Map<String, dynamic>>? nopList,
    List<Map<String, dynamic>>? filteredNopList,
    String? errorMessage,
    SearchOpType? selectedType,
  }) {
    return SearchOpState(
      isLoading: isLoading ?? this.isLoading,
      nopList: nopList ?? this.nopList,
      filteredNopList: filteredNopList ?? this.filteredNopList,
      errorMessage: errorMessage,
      selectedType: selectedType ?? this.selectedType,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    nopList,
    filteredNopList,
    errorMessage,
    selectedType,
  ];
}
