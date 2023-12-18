import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesProvider {
  static SharedPreferences? _prefs;

  static Future<SharedPreferences?> initAndGetInstance() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs;
  }
}