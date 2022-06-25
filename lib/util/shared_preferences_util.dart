 import 'package:shared_preferences/shared_preferences.dart';


class SharedPreferencesUtil {

  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  /// 儲存資料
  static saveData<type>(String key, type value) async {
    final prefs = await SharedPreferences.getInstance();

    switch (type) {
      case int:
        await prefs.setInt(key, value as int);
        break;
      case bool:
        await prefs.setBool(key, value as bool);
        break;
      case double:
        await prefs.setDouble(key, value as double);
        break;
      case String:
        await prefs.setString(key, value as String);
        break;
      case List<String>:
        await prefs.setStringList(key, value as List<String>);
        break;
    }
  }
  /// 讀取資料
  static dynamic getData<type>(String key) async {
    final prefs = await SharedPreferences.getInstance();

    switch (type) {
      case int:
        final int? res = prefs.getInt(key);
        return res;
      case bool:
        final bool? res = prefs.getBool(key);
        return res;
      case double:
        final double? res = prefs.getDouble(key);
        return res;
      case String:
        final String? res = prefs.getString(key);
        return res;
      case List<String>:
        final List<String>? res = prefs.getStringList(key);
        return res;
    }

    return null;
  }











}