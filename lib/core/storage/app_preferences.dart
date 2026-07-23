import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'preference_keys.dart';

@lazySingleton
class AppPreferences {
  final SharedPreferences _prefs;

  AppPreferences(this._prefs);

  // --- JENIS OBJEK PENGAWASAN ---
  Future<bool> saveJenisObjekPengawasan(String value) async {
    return await _prefs.setString(PreferenceKeys.jenisObjekPengawasan, value);
  }

  String? getjJnisObjekPengawasan() {
    return _prefs.getString(PreferenceKeys.jenisObjekPengawasan);
  }

  Future<bool> removeJenisObjekPengawasan() async {
    return await _prefs.remove(PreferenceKeys.jenisObjekPengawasan);
  }

  // --- SHIFT OBJEK PENGAWASAN ---
  Future<bool> saveShiftObjekPengawasan(String value) async {
    return await _prefs.setString(PreferenceKeys.shiftObjekPengawasan, value);
  }

  String? getShiftObjekPengawasan() {
    return _prefs.getString(PreferenceKeys.shiftObjekPengawasan);
  }

  Future<bool> removeShiftObjekPengawasan() async {
    return await _prefs.remove(PreferenceKeys.shiftObjekPengawasan);
  }

  // --- NOMOR OBJEK PENGAWASAN  ---

  Future<bool> saveNomorObjekPengawasan(String value) async {
    return await _prefs.setString(PreferenceKeys.nomorObjekPengawasan, value);
  }

  String? getNomorObjekPengawasan() {
    return _prefs.getString(PreferenceKeys.nomorObjekPengawasan);
  }

  Future<bool> removeNomorObjekPengawasan() async {
    return await _prefs.remove(PreferenceKeys.nomorObjekPengawasan);
  }

  /// Menghapus SELURUH data di dalam SharedPreferences
  Future<bool> clearAllPreferences() async {
    return await _prefs.clear();
  }
}
