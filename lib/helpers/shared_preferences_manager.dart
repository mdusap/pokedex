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

  List<String> getStringList(String key, {List<String> defaultValue = const []}) {
    return _prefs.getStringList(key) ?? defaultValue;
  }

  Future<bool> setStringList(String key, List<String> value) async {
    return await _prefs.setStringList(key, value);
  }

  Set<String> getSetString(String key, {Set<String> defaultValue = const {}}) {
    return (_prefs.getStringList(key) ?? []).toSet();
  }

  Future<bool> setSetString(String key, Set<String> value) async {
    return await _prefs.setStringList(key, value.toList());
  }

  List<String> getEmptyStringList(String key) {
    return _prefs.getStringList(key) ?? [];
  }

  Future<bool> setEmptyStringList(String key) async {
    return await _prefs.setStringList(key, []);
  }

  String getString(String key, {String defaultValue = ''}) {
    return _prefs.getString(key) ?? defaultValue;
  }

  Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }
}
