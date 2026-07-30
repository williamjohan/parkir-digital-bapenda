import 'package:equatable/equatable.dart';

class LoginEntity extends Equatable {
  final String accessToken;
  final String refreshToken;
  final String nop;
  final String idDevice;
  final String lastUpdateOp;

  const LoginEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.nop,
    required this.idDevice,
    required this.lastUpdateOp,
  });

  @override
  List<Object?> get props => [
    accessToken,
    refreshToken,
    nop,
    idDevice,
    lastUpdateOp,
  ];
}
