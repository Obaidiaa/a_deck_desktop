import 'package:a_deck_desktop/app/deck/deck_view_model.dart';
import 'package:a_deck_desktop/app/models/settings.dart';
import 'package:a_deck_desktop/app/settings/setting_page.dart';
import 'package:a_deck_desktop/app/top_level_providers.dart';
import 'package:a_deck_desktop/services/shared_preferences_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final settingsViewModelProvider = Provider((ref) {
  final sharedPreferencesService = ref.watch(sharedPreferencesServiceProvider);
  return SettingViewModel(
      sharedPreferencesService: sharedPreferencesService, ref: ref);
});

final settingsProvider = Provider.autoDispose<Settings>((ref) {
  final sharedPreferencesService = ref.watch(sharedPreferencesServiceProvider);
  return sharedPreferencesService.getSettings();
});

class SettingViewModel extends StateNotifier<Settings> {
  final SharedPreferencesService sharedPreferencesService;
  final ProviderRef ref;
  SettingViewModel({required this.sharedPreferencesService, required this.ref})
      : super(Settings(serverIp: "", serverPort: "")) {
    // getSettings();
  }

  // void getSettings() {
  //   state = sharedPreferencesService.getSettings();
  // }

  setSettings(ip, port) {
    sharedPreferencesService.setSettings(ip, port);
    // ref.refresh(settingsProvider);
    ref.refresh(deckCommandProvider);
    // state = Settings(serverIp: ip, serverPort: port);
  }

  deleteSetting() {
    sharedPreferencesService.deleteSettings();
    // ref.refresh(settingsProvider);
  }
}
