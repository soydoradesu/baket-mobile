import 'package:shared_preferences/shared_preferences.dart';

import 'logger_service.dart';

/// SharedPreferences in Flutter is used to store primitive data types locally
/// in key-value pair. Harusnya ini bisa buat save login state user, but nanti
/// gw bakal pikirin lagi.
class PrefService {
  static SharedPreferences? _pref;

  static Future<void> init() async {
    LoggerService.i('Initializing Shared Preference Service');
    _pref = await SharedPreferences.getInstance();
  }

  static Future<void> saveString(String key, String value) async {
    await _pref!.setString(key, value);
  }

  static Future<void> saveInt(String key, int value) async {
    await _pref!.setInt(key, value);
  }

  static String? getString(String key) {
    return _pref!.getString(key);
  }

  static int? getInt(String key) {
    return _pref!.getInt(key);
  }

  static Future<void> removeKey(String key) async {
    await _pref!.remove(key);
  }
}
