import 'package:shared_preferences/shared_preferences.dart';

const _prefEnvUrlKey = "envUrl";
const _envUrlDefaultValue = "platform-api.dev03.glowfinsvs.com";

class EeUrlProvider {
  static String _baseUrl = "";
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
    _baseUrl = _prefs?.getString(_prefEnvUrlKey) ?? _envUrlDefaultValue;
  }

  static Future<void> setNewEnvUrl(String newUrl) async {
    _prefs?.setString(_prefEnvUrlKey, newUrl);
    _baseUrl = newUrl;
  }

  static String getCurrentEnvUrl() => _baseUrl;
}


