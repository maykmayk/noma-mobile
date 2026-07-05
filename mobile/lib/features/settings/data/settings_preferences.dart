import 'package:shared_preferences/shared_preferences.dart';

abstract final class SettingsPreferences {
  static const _keyVoice = 'pref_voice_enabled';
  static const _keyHaptic = 'pref_haptic_enabled';

  static Future<bool> getVoiceEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyVoice) ?? true;
  }

  static Future<void> setVoiceEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyVoice, value);
  }

  static Future<bool> getHapticEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyHaptic) ?? true;
  }

  static Future<void> setHapticEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyHaptic, value);
  }
}
