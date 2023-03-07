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

  // TTSVolume
  static Future<bool> setTTSVolume(double value) async {
    if (value < 0.0) {
      value = 0.0;
    }
    if (value > 1.0) {
      value = 1.0;
    }
    saveData<double>('applicationSettingsDataTtsVolume', value);
    return true;
  }

  static Future<double> getTTSVolume() async {
    double? res = await getData<double>('applicationSettingsDataTtsVolume');
    if (res == null) {
      res = 0.5;
      setTTSVolume(res);
    }
    return res;
  }

  // TTSPitch
  static Future<bool> setTTSPitch(double value) async {
    if (value < 0.5) {
      value = 0.5;
    }
    if (value > 2.0) {
      value = 2.0;
    }
    saveData<double>('applicationSettingsDataTtsPitch', value);
    return true;
  }

  static Future<double> getTTSPitch() async {
    double? res = await getData<double>('applicationSettingsDataTtsPitch');
    if (res == null) {
      res = 1.0;
      setTTSPitch(res);
    }
    return res;
  }

  // TTSRate
  static Future<bool> setTTSRate(double value) async {
    if (value <= 0.125) {
      value = 0.125;
    }
    if (0.125 < value && value <= 0.25) {
      value = 0.25;
    }
    if (0.25 < value && value <= 0.375) {
      value = 0.375;
    }
    if (0.375 < value && value <= 0.5) {
      value = 0.5;
    }
    if (0.5 < value && value <= 0.625) {
      value = 0.625;
    }
    if (0.625 < value && value <= 0.75) {
      value = 0.75;
    }
    if (0.75 < value && value <= 0.875) {
      value = 0.875;
    }
    if (0.875 < value) {
      value = 1.0;
    }
    saveData<double>('applicationSettingsDataTtsRate', value);
    setTTSRateString();

    print('setTTSRate: $value');
    return true;
  }

  static Future<double> getTTSRate() async {
    double? res = await getData<double>('applicationSettingsDataTtsRate');
    if (res == null) {
      res = 0.5;
      setTTSRate(res);
    }
    return res;
  }

  // TTSRateString
  static Future<bool> setTTSRateString() async {
    double rate = await getTTSRate();
    String rateString = '';

    int rateInt = (rate * 1000).toInt();

    switch (rateInt) {
      case 125:
        rateString = '0.25倍';
        break;
      case 250:
        rateString = '0.5倍';
        break;
      case 375:
        rateString = '0.75倍';
        break;
      case 500:
        rateString = '一般';
        break;
      case 625:
        rateString = '1.25倍';
        break;
      case 750:
        rateString = '1.5倍';
        break;
      case 875:
        rateString = '1.75倍';
        break;
      case 1000:
        rateString = '2倍';
        break;
    }

    saveData<String>('applicationSettingsDataTtsRateString', rateString);
    return true;
  }

  static Future<String> getTTSRateString() async {
    /*
    String? res = await getData<String>('applicationSettingsDataTtsRateString');
    if (res == null) {
      res = '';
    }
    return res;

     */

    double rate = await getTTSRate();
    String rateString = '';

    int rateInt = (rate * 1000).toInt();

    switch (rateInt) {
      case 125:
        rateString = '0.25倍';
        break;
      case 250:
        rateString = '0.5倍';
        break;
      case 375:
        rateString = '0.75倍';
        break;
      case 500:
        rateString = '一般';
        break;
      case 625:
        rateString = '1.25倍';
        break;
      case 750:
        rateString = '1.5倍';
        break;
      case 875:
        rateString = '1.75倍';
        break;
      case 1000:
        rateString = '2倍';
        break;
    }

    return rateString;
  }
}
