// lib/core/network/network_cubit.dart

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

abstract class NetworkState {}

class NetworkInitial extends NetworkState {}

class NetworkConnected extends NetworkState {}

class NetworkDisconnected extends NetworkState {}

@lazySingleton
class NetworkCubit extends Cubit<NetworkState> {
  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  // Injeksi Connectivity dari module DI Anda, atau inisialisasi langsung
  NetworkCubit(this._connectivity) : super(NetworkInitial()) {
    _monitorConnection();
  }

  void _monitorConnection() {
    _subscription = _connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      // connectivity_plus versi terbaru mengembalikan List
      if (results.contains(ConnectivityResult.none)) {
        emit(NetworkDisconnected());
      } else {
        emit(NetworkConnected());
      }
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
