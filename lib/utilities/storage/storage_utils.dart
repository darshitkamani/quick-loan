import 'package:shared_preferences/shared_preferences.dart';

class StorageUtils {
  static late SharedPreferences prefs;

  static writeStringValue({required String key, required String value}) {
    return prefs.setString(key, value);
  }

  static String? readStringValue({required String key}) {
    return prefs.getString(key);
  }

  static Future<bool>? removeStringValue({required String key}) {
    return prefs.remove(key);
  }

  static writeBoolValue({required String key, required bool value}) {
    return prefs.setBool(key, value);
  }

  static bool? readBoolValue({required String key}) {
    return prefs.getBool(key);
  }

  static clearPrefs() async {
    await prefs.clear();
  }

  static removePrefsKey(String key) async {
    await prefs.remove(key);
  }
}
