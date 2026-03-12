import 'package:equatable/equatable.dart';

class LoginEntity extends Equatable {
  final String accessToken;
  final String refreshToken;
  final String nop;
  final String idDevice;

  const LoginEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.nop,
    required this.idDevice,
  });

  @override
  List<Object?> get props => [accessToken, refreshToken, nop, idDevice];
}
