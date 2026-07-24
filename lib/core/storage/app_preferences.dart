import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../enums/app_enums.dart';
import 'preference_keys.dart';

@lazySingleton
class AppPreferences {
  final SharedPreferences _prefs;

  AppPreferences(this._prefs);

  // ---------------------------------------------------------------------------
  // --- JENIS OBJEK PENGAWASAN (Disimpan sebagai String Code) ---
  // ---------------------------------------------------------------------------
  Future<bool> saveJenisObjekPengawasan(JenisPengawasan jenis) async {
    // Mengekstrak 'code' dari Enum untuk disimpan sebagai String
    return await _prefs.setString(
      PreferenceKeys.jenisObjekPengawasan,
      jenis.code,
    );
  }

  JenisPengawasan? getJenisObjekPengawasan() {
    final code = _prefs.getString(PreferenceKeys.jenisObjekPengawasan);
    if (code == null) return null;
    return JenisPengawasan.fromCode(code);
  }

  Future<bool> removeJenisObjekPengawasan() async {
    return await _prefs.remove(PreferenceKeys.jenisObjekPengawasan);
  }

  // ---------------------------------------------------------------------------
  // --- SHIFT OBJEK PENGAWASAN (Disimpan sebagai Integer ID) ---
  // ---------------------------------------------------------------------------
  Future<bool> saveShiftObjekPengawasan(ShiftPengawasan shift) async {
    return await _prefs.setInt(PreferenceKeys.shiftObjekPengawasan, shift.id);
  }

  ShiftPengawasan? getShiftObjekPengawasan() {
    final id = _prefs.getInt(PreferenceKeys.shiftObjekPengawasan);
    if (id == null) return null;

    return ShiftPengawasan.fromId(id);
  }

  Future<bool> removeShiftObjekPengawasan() async {
    return await _prefs.remove(PreferenceKeys.shiftObjekPengawasan);
  }

  // ---------------------------------------------------------------------------
  // --- NOMOR OBJEK PENGAWASAN (Tetap String Bebas) ---
  // ---------------------------------------------------------------------------
  Future<bool> saveNomorObjekPengawasan(String value) async {
    return await _prefs.setString(PreferenceKeys.nomorObjekPengawasan, value);
  }

  String? getNomorObjekPengawasan() {
    return _prefs.getString(PreferenceKeys.nomorObjekPengawasan);
  }

  Future<bool> removeNomorObjekPengawasan() async {
    return await _prefs.remove(PreferenceKeys.nomorObjekPengawasan);
  }

  // ---------------------------------------------------------------------------
  // --- PEMBERSIHAN ---
  // ---------------------------------------------------------------------------

  /// Menghapus SELURUH data di dalam SharedPreferences saat Logout
  Future<bool> clearAllPreferences() async {
    return await _prefs.clear();
  }
}
