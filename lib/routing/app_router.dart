// app routes

import 'package:a_deck_desktop/app/commands/add_command_page.dart';
import 'package:a_deck_desktop/app/commands/commands_page.dart';
import 'package:a_deck_desktop/app/deck/deck_page.dart';
import 'package:a_deck_desktop/app/home/home_page.dart';
import 'package:a_deck_desktop/app/models/settings.dart';
import 'package:a_deck_desktop/app/settings/setting_page.dart';
import 'package:a_deck_desktop/app/setup/setup_page.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const deckPage = '/deck-page';
  static const settingPage = '/setting-page';
  static const setupPage = '/setup-page';
  static const commandsPage = '/commands-page';
  static const commandAddPage = '/command-add-page';

  static const homePage = '/';
}

class AppRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case AppRoutes.homePage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const HomePage(),
          settings: settings,
          fullscreenDialog: true,
        );
      case AppRoutes.deckPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const DeckPage(),
          settings: settings,
          fullscreenDialog: true,
        );
      case AppRoutes.settingPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => SettingPage(settings: args as Settings?),
          settings: settings,
          fullscreenDialog: true,
        );
      case AppRoutes.setupPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => SetupPage(settings: args as Settings?),
          settings: settings,
          fullscreenDialog: true,
        );
      case AppRoutes.commandsPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const CommandsPage(),
          fullscreenDialog: true,
        );
      case AppRoutes.commandAddPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => const AddCommand(),
          fullscreenDialog: true,
        );
      default:
        return null;
    }
  }
}
