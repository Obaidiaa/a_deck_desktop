// home page nothing else for now

import 'dart:math';

import 'package:a_deck_desktop/app/commands/commands_page.dart';
import 'package:a_deck_desktop/app/deck/deck_page.dart';
import 'package:a_deck_desktop/app/deck/deck_view_model.dart';
import 'package:a_deck_desktop/app/models/settings.dart';
import 'package:a_deck_desktop/app/settings/setting_page.dart';
import 'package:a_deck_desktop/app/top_level_providers.dart';
import 'package:a_deck_desktop/routing/app_router.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  // final Settings settings;

  static Future<void> show(BuildContext context, {Settings? settings}) async {
    await Navigator.of(context, rootNavigator: true).pushNamed(
      AppRoutes.homePage,
      arguments: settings,
    );
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text("A Deck"),
        actions: [
          ElevatedButton(
              onPressed: () => SettingPage.show(context),
              child: const Text('Settings')),
          ElevatedButton(
              onPressed: () => CommandsPage.show(context),
              child: const Text('Commands'))
        ],
      ),
      body: const DeckPage(),
    ));
  }
}
