import 'package:equatable/equatable.dart';

import '../../../../../core/enums/app_enums.dart';

class SearchOpState extends Equatable {
  final bool isLoading;
  final List<Map<String, dynamic>> nopList;
  final String? errorMessage;

  const SearchOpState({
    this.isLoading = false,
    this.nopList = const [],
    this.errorMessage,
  });

  SearchOpState copyWith({
    bool? isLoading,
    List<Map<String, dynamic>>? nopList,
    String? errorMessage,
  }) {
    return SearchOpState(
      isLoading: isLoading ?? this.isLoading,
      nopList: nopList ?? this.nopList,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, nopList, errorMessage];
}
