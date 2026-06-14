import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import '../../domain/entities/qris_entity.dart';
import '../../../parking_transaction/data/models/local_transaction_model.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

// ─── STATE BARU: QRIS ROMPI (LOKAL / STATIS) ─────────────────────────────────

/// Sedang membaca image path dari secured storage
class PaymentLocalQrisLoading extends PaymentState {}

/// Image path QRIS berhasil dibaca — siap ditampilkan
class PaymentLocalQrisReady extends PaymentState {
  final String qrisImagePath;
  const PaymentLocalQrisReady(this.qrisImagePath);

  @override
  List<Object?> get props => [qrisImagePath];
}

/// QRIS tidak ditemukan di local storage (belum sync / kendaraan tidak dikenal)
class PaymentLocalQrisError extends PaymentState {
  final String message;
  const PaymentLocalQrisError(this.message);

  @override
  List<Object?> get props => [message];
}

// ─── STATE LAMA: QRIS DINAMIS (GENERATE API) — dipertahankan sementara ───────
// TODO: Hapus state-state di bawah setelah flow QRIS Dinamis tidak dipakai lagi

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

/// [LEGACY] QRIS dari API sudah siap (base64 → bytes)
class PaymentQrisReady extends PaymentState {
  final QrisEntity qris;
  final Uint8List qrisBytes;

  const PaymentQrisReady(this.qris, this.qrisBytes);

  @override
  List<Object?> get props => [qris, qrisBytes];
}

/// [LEGACY] Sedang sinkronisasi transaksi ke server
class PaymentSyncing extends PaymentState {}

/// [LEGACY] Pembayaran berhasil — transaksi tersimpan
class PaymentSuccess extends PaymentState {
  final String message;
  final LocalTransactionModel transaction;

  const PaymentSuccess(this.message, this.transaction);

  @override
  List<Object?> get props => [message, transaction];
}

class PaymentError extends PaymentState {
  final String message;
  const PaymentError(this.message);

  @override
  List<Object?> get props => [message];
}

class PaymentTimeout extends PaymentState {
  final String message;
  const PaymentTimeout(this.message);

  @override
  List<Object?> get props => [message];
}

/// Overlay loading saat cek status manual
class PaymentCheckLoading extends PaymentState {}

/// Snackbar info ketika pembayaran masih pending
class PaymentPendingInfo extends PaymentState {
  final String message;
  const PaymentPendingInfo(this.message);

  @override
  List<Object?> get props => [message];
}
