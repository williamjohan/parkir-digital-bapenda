// lib/features/auth/presentation/cubit/app_auth/app_auth_state.dart

import 'package:equatable/equatable.dart';

abstract class AppAuthState extends Equatable {
  const AppAuthState();

  @override
  List<Object> get props => [];
}

/// Status awal saat aplikasi baru dibuka (biasanya trigger Splash Screen)
class AppAuthInitial extends AppAuthState {}

/// Jukir memiliki token valid di brankas (Arahkan ke Home)
class AppAuthenticated extends AppAuthState {}

/// Jukir tidak punya token, atau tokennya sudah basi (Arahkan ke Login)
class AppUnauthenticated extends AppAuthState {}
