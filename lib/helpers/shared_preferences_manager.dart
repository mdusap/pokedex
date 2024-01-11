import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  static SharedPreferencesManager? _instance;
  late SharedPreferences _prefs;

  SharedPreferencesManager._internal();

  factory SharedPreferencesManager() {
    return _instance ??= SharedPreferencesManager._internal();
  }

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  bool getBool(String key, {bool defaultValue = false}) {
    return _prefs.getBool(key) ?? defaultValue;
  }

  Future<bool> setBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  List<String> getStringList(String key,
      {List<String> defaultValue = const []}) {
    return _prefs.getStringList(key) ?? defaultValue;
  }

  Future<bool> setStringList(String key, List<String> value) async {
    return await _prefs.setStringList(key, value);
  }

  List<String> getEmptyStringList(String key) {
    return _prefs.getStringList(key) ?? [];
  }

  Future<bool> setEmptyStringList(String key) async {
    return await _prefs.setStringList(key, []);
  }
}
