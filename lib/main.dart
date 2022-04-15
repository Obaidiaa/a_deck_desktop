import 'package:a_deck_desktop/app/home/home_page.dart';
import 'package:a_deck_desktop/routing/app_router.dart';
import 'package:a_deck_desktop/services/shared_preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(ProviderScope(overrides: [
    sharedPreferencesServiceProvider.overrideWithValue(
      SharedPreferencesService(sharedPreferences),
    ),
  ], child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Consumer(
        builder: (context, ref, child) {
          return const HomePage();
          // final settingLoaded = ref.watch(sharedPreferencesServiceProvider);
          // return settingLoaded.getSettings().serverIp != ""
          // ? const HomePage()
          // : const CommandsPage();
        },
      ),
      onGenerateRoute: (settings) => AppRouter.onGenerateRoute(settings),
    );
  }
}
