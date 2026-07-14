import 'package:equatable/equatable.dart';

class OpLastUpdateEntity extends Equatable {
  final bool isSuccess;
  final int statusCode;
  final String message;
  final String data;

  const OpLastUpdateEntity({
    required this.isSuccess,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  @override
  List<Object?> get props => [isSuccess, statusCode, message, data];
}
