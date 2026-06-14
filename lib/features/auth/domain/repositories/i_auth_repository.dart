// lib/features/auth/domain/repositories/i_auth_repository.dart

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

  // cek uuid
  Future<bool> checkDeviceUuid();
}
