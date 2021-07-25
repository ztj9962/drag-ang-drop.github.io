import 'package:shared_preferences/shared_preferences.dart';


class SharedPreferencesUtil {

  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  /// 儲存資料
  static saveData<T>(String key, T value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    switch (T) {
      case String:
        prefs.setString(key, value as String);
        break;
      case int:
        prefs.setInt(key, value as int);
        break;
      case bool:
        prefs.setBool(key, value as bool);
        break;
      case double:
        prefs.setDouble(key, value as double);
        break;
    }
  }
  /// 讀取資料
  static Future<String?> getStringData(String key) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(key);
  }

  static Future<int?> getIntegerData(String key) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getInt(key);
  }

  static Future<double?> getDoubleData(String key) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getDouble(key);
  }

  static Future<bool?> getBoolData(String key) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getBool(key);
  }


  /// 讀取資料
  static Future<T?> getData<T>(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    T? res;
    switch (T) {
      case String:
        res = prefs.getString(key) as T?;
        break;
      case int:
        res = prefs.getInt(key) as T?;
        break;
      case bool:
        res = prefs.getBool(key) as T?;
        break;
      case double:
        res = prefs.getDouble(key) as T?;
        break;
    }
    return res;
  }











}