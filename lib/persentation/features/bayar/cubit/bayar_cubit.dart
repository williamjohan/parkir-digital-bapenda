import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/bayar_repository.dart';
import '../data/objek_pajak_model.dart';
import '../data/transaction_model.dart';

// --- STATES ---
abstract class BayarState extends Equatable {
  const BayarState();
  @override
  List<Object> get props => [];
}

class BayarInitial extends BayarState {}

class BayarLoading extends BayarState {}

class BayarLoaded extends BayarState {
  final List<ObjekPajakModel> listObjekPajak;
  const BayarLoaded(this.listObjekPajak);
  @override
  List<Object> get props => [listObjekPajak];
}

class BayarError extends BayarState {
  final String message;
  const BayarError(this.message);
  @override
  List<Object> get props => [message];
}

class BayarPaymentLoading extends BayarState {} // Saat tombol ditekan

class BayarPaymentSuccess extends BayarState {
  final TransactionModel transaction;
  const BayarPaymentSuccess(this.transaction);
  @override
  List<Object> get props => [transaction];
}

// --- CUBIT ---
class BayarCubit extends Cubit<BayarState> {
  final BayarRepository repository;

  // Kita simpan listObjekPajak di memory agar tidak hilang saat state berubah
  List<ObjekPajakModel> _tempList = [];

  BayarCubit(this.repository) : super(BayarInitial());

  Future<void> fetchObjekPajak() async {
    emit(BayarLoading());
    try {
      final data = await repository.getObjekPajak();
      _tempList = data; // Simpan ke memory
      emit(BayarLoaded(data));
    } catch (e) {
      emit(BayarError(e.toString()));
    }
  }

  // FUNCTION BARU: PAY NOW
  Future<void> payNow({
    required String nop,
    required String vehicleType,
    required String paymentMethod,
    required int amount,
  }) async {
    // 1. Emit Loading Pembayaran
    emit(BayarPaymentLoading());

    try {
      // 2. Panggil Repo
      final result = await repository.insertTransaction(
        nop: nop,
        vehicleType: vehicleType,
        paymentMethod: paymentMethod,
        amount: amount,
      );

      // 3. Sukses
      emit(BayarPaymentSuccess(result));

      // Optional: Kembalikan ke state Loaded agar dropdown muncul lagi
      // emit(BayarLoaded(_tempList));
    } catch (e) {
      emit(BayarError("Gagal Bayar: ${e.toString()}"));
      // Kembalikan data lama biar user bisa coba lagi
      emit(BayarLoaded(_tempList));
    }
  }

  // Helper untuk reset state setelah sukses dialog ditutup
  void resetToLoaded() {
    emit(BayarLoaded(_tempList));
  }
}
