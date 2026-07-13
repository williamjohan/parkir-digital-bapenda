abstract class IAudioNotificationService {
  Future<void> init();
  Future<void> playPaymentSuccess(int nominal);
  Future<void> playStaticBeep();
  void dispose();
}
