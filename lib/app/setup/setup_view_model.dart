import 'package:a_deck_desktop/app/models/settings.dart';
import 'package:a_deck_desktop/app/settings/setting_page.dart';
import 'package:a_deck_desktop/app/top_level_providers.dart';
import 'package:a_deck_desktop/services/shared_preferences_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final setupViewModelProvider = Provider((ref) {
  final sharedPreferencesService = ref.watch(sharedPreferencesServiceProvider);
  return SetupViewModel(sharedPreferencesService);
});

final setupProvider = Provider.autoDispose<Settings>((ref) {
  final sharedPreferencesService = ref.watch(sharedPreferencesServiceProvider);
  return sharedPreferencesService.getSettings();
});

class SetupViewModel extends StateNotifier<Settings> {
  final SharedPreferencesService sharedPreferencesService;

  SetupViewModel(this.sharedPreferencesService)
      : super(Settings(serverIp: "", serverPort: "")) {
    getSettings();
  }

  void getSettings() {
    state = sharedPreferencesService.getSettings();
  }

  void setSettings(ip, port) {
    sharedPreferencesService.setSettings(ip, port);
    state = Settings(serverIp: ip, serverPort: port);
  }
}
