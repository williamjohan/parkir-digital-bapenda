import 'package:equatable/equatable.dart';

class SearchOpState extends Equatable {
  final bool isLoading;
  final List<Map<String, dynamic>> nopList;
  final List<Map<String, dynamic>> filteredNopList;
  final String? errorMessage;

  const SearchOpState({
    this.isLoading = false,
    this.nopList = const [],
    this.filteredNopList = const [],
    this.errorMessage,
  });

  SearchOpState copyWith({
    bool? isLoading,
    List<Map<String, dynamic>>? nopList,
    List<Map<String, dynamic>>? filteredNopList,
    String? errorMessage,
  }) {
    return SearchOpState(
      isLoading: isLoading ?? this.isLoading,
      nopList: nopList ?? this.nopList,
      filteredNopList: filteredNopList ?? this.filteredNopList,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    nopList,
    filteredNopList,
    errorMessage,
  ];
}
