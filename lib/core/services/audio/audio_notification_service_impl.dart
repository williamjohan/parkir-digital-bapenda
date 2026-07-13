import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:parkir_digital_bapenda/core/utils/app_logger.dart';
import '../../constants/app_asset_constant.dart';
import 'i_audio_notification_service.dart';

class AudioNotificationServiceImpl implements IAudioNotificationService {
  late final AudioPlayer _audioPlayer;
  late final FlutterTts _flutterTts;

  @override
  Future<void> init() async {
    _audioPlayer = AudioPlayer();
    _flutterTts = FlutterTts();

    // 🚀 1. Konfigurasi TTS untuk Bahasa Indonesia
    await _flutterTts.setLanguage("id-ID");
    await _flutterTts.setSpeechRate(0.5); // Kecepatan bicara normal & jelas
    await _flutterTts.setVolume(1.0); // Volume maksimal untuk jalanan bising
    await _flutterTts.setPitch(1.0);

    // 🚀 2. Pre-load audio statis agar diputar tanpa delay
    await _audioPlayer.setSource(AssetSource(AppAssetAudio.successAudio));
  }

  @override
  Future<void> playPaymentSuccess(int nominal) async {
    try {
      // 🚀 1. Putar nada dering statis instan terlebih dahulu (0.5 detik)
      await _audioPlayer.play(AssetSource('audio/success_chime.mp3'));

      // 🚀 2. Beri jeda sedikit agar tidak menabrak nada dering
      await Future.delayed(const Duration(milliseconds: 600));

      // 🚀 3. Ubah angka menjadi teks dan bacakan!
      // Contoh hasil: "Pembayaran lima ribu rupiah berhasil"
      final nominalText = _terbilang(nominal);
      final speechText = "Pembayaran $nominalText rupiah berhasil";

      await _flutterTts.speak(speechText);
    } catch (e) {
      // 🚀 DEFENSIVE: Jangan biarkan kegagalan audio memicu crash aplikasi!
      // Cukup log error-nya, transaksi Jukir tetap harus berlanjut.
      AppLogger.debug("Gagal memutar suara pembayaran: $e");
    }
  }

  @override
  Future<void> playStaticBeep() async {
    try {
      await _audioPlayer.play(AssetSource(AppAssetAudio.successAudio));
    } catch (_) {}
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _flutterTts.stop();
  }

  // Helper sederhana untuk mengubah angka jadi teks terbilang (Opsional,
  // karena flutter_tts modern sebenarnya sudah pintar membaca angka langsung:
  // _flutterTts.speak("Pembayaran $nominal rupiah berhasil") juga sudah bekerja bagus!
  String _terbilang(int angka) {
    // Anda bisa menggunakan package 'terbilang' dari pub.dev
    // atau cukup biarkan flutter_tts membaca angkanya secara native.
    return angka.toString();
  }
}
