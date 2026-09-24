import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:parkir_digital_bapenda/core/utils/app_logger.dart';
import '../../constants/app_asset_constant.dart';
import 'i_audio_notification_service.dart';

class AudioNotificationServiceImpl implements IAudioNotificationService {
  late final FlutterTts _flutterTts;
  bool _isTtsInitialized = false;

  // EDGE CASE 1 FIX: Mutex Lock untuk mencegah suara bertumpuk
  bool _isCurrentlyPlaying = false;

  @override
  Future<void> init() async {
    _flutterTts = FlutterTts();
    try {
      await _flutterTts.setLanguage("id-ID");
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);
      _isTtsInitialized = true;
    } catch (e) {
      AppLogger.debug("Gagal inisialisasi TTS: $e");
    }
  }

  @override
  Future<void> playPaymentSuccess(int nominal) async {
    // 🛡️ Cegah pemanggilan ganda jika audio sedang berjalan
    if (_isCurrentlyPlaying) return;
    _isCurrentlyPlaying = true;

    final AudioPlayer localPlayer = AudioPlayer();

    try {
      // 1. Putar suara sukses
      await localPlayer.play(AssetSource(AppAssetAudio.successAudio));

      // EDGE CASE 2 FIX: Tunggu sampai selesai, TAPI batasi maksimal 2 detik!
      // Jika nyangkut, timeout akan dilempar, dan kita menangkapnya di catch
      await localPlayer.onPlayerComplete.first.timeout(
        const Duration(seconds: 2),
      );
    } catch (e) {
      // Jika terjadi Timeout atau file tidak bisa diputar, abaikan saja
      // agar proses TTS tetap bisa dieksekusi.
      AppLogger.debug("Audio Player peringatan (lanjut ke TTS): $e");
    } finally {
      // Pastikan resource native Android (Xiaomi) selalu dilepaskan!
      await localPlayer.dispose();
    }

    // 2. Eksekusi TTS (Text-to-Speech)
    if (_isTtsInitialized) {
      try {
        // Hentikan paksa jika TTS sebelumnya masih cerewet
        await _flutterTts.stop();

        final nominalText = _terbilang(nominal);
        final speechText = "Pembayaran $nominalText rupiah berhasil";
        await _flutterTts.speak(speechText);
      } catch (e) {
        AppLogger.debug("Gagal eksekusi TTS: $e");
      }
    }

    // Lepaskan gembok setelah semua tugas selesai
    _isCurrentlyPlaying = false;
  }

  @override
  Future<void> playStaticBeep() async {
    // Cukup gunakan pola yang sama tanpa lock ketat
    final AudioPlayer localPlayer = AudioPlayer();
    try {
      await localPlayer.play(AssetSource(AppAssetAudio.successAudio));
      await localPlayer.onPlayerComplete.first.timeout(
        const Duration(seconds: 2),
      );
    } catch (_) {
    } finally {
      await localPlayer.dispose();
    }
  }

  @override
  void dispose() {
    _flutterTts.stop();
  }

  String _terbilang(int angka) {
    return angka.toString();
  }
}
