enum PaymentStatus {
  idle,
  pending,
  lunas,
  timeout,
  error,
  unknown;

  /// Helper untuk konversi string dari SignalR/API ke Enum
  static PaymentStatus fromString(String status) {
    switch (status.toUpperCase()) {
      case 'LUNAS':
      case 'PAID':
      case 'SUCCESS':
        return PaymentStatus.lunas;
      case 'PENDING':
        return PaymentStatus.pending;
      case 'TIMEOUT':
      case 'EXPIRED':
        return PaymentStatus.timeout;
      case 'ERROR':
      case 'FAILED':
        return PaymentStatus.error;
      default:
        return PaymentStatus.unknown;
    }
  }
}
