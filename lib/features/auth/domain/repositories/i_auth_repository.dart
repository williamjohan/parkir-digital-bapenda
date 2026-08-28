import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';

abstract class IAuthRepository {
  /// Proses login yang mengembalikan [Unit] (kosong/void) jika sukses,
  /// atau [Failure] jika gagal.
  Future<Either<Failure, Unit>> login(String username, String password);

  /// Proses logout (membersihkan token lokal dan/atau tembak API logout)
  Future<Either<Failure, Unit>> logout();

  /// Mengecek apakah sesi Jukir masih aktif di HP ini
  Future<bool> checkAuthStatus();
  Future<bool> checkDeviceUuid();

  /// Login dengan Kantorku
  Future<Either<Failure, String>> getKantorkuSsoUrl();
  Stream<String> get ssoTokenStream;

  /// Login dengan SessionId dari kantorku
  Future<Either<Failure, Unit>> loginWithKantorkuSession(String sessionId);

  Future<void> saveCredentials(String username, String password);
}
