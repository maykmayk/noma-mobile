import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/settings_preferences.dart';

final voiceEnabledProvider =
    AsyncNotifierProvider<VoiceEnabledNotifier, bool>(VoiceEnabledNotifier.new);

class VoiceEnabledNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() => SettingsPreferences.getVoiceEnabled();

  Future<void> set(bool value) async {
    await SettingsPreferences.setVoiceEnabled(value);
    state = AsyncValue.data(value);
  }
}

final hapticEnabledProvider =
    AsyncNotifierProvider<HapticEnabledNotifier, bool>(HapticEnabledNotifier.new);

class HapticEnabledNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() => SettingsPreferences.getHapticEnabled();

  Future<void> set(bool value) async {
    await SettingsPreferences.setHapticEnabled(value);
    state = AsyncValue.data(value);
  }
}
