import 'package:a_deck_desktop/app/models/settings.dart';
import 'package:a_deck_desktop/services/data_api.dart';
import 'package:a_deck_desktop/services/shared_preferences_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// final prefDataProvider = Provider<SharedPreferencesService>((ref) {
//   return sharedPreferencesServiceProvider;
// });
// final sharedPreferencesServiceProvider =
//     StateNotifierProvider<SharedPreferencesService, Settings>((ref) {
//   final sharedPreferences = SharedPreferences.getInstance();
//   return SharedPreferencesService(sharedPreferences);
// });

// final sharedPreferencesServiceProvider =
//     Provider.autoDispose<SharedPreferencesService>(
//         (ref) => throw );

// final dataProvider = Provider.autoDispose<DataApi?>((ref) {
//   final settings = ref.watch(sharedPreferencesServiceProvider);
//   return DataApi(settings: settings.getSettings());
// });
