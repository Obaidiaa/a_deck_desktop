// load data from server

import 'dart:io';

import 'package:a_deck_desktop/app/commands/commands_view_model.dart';
import 'package:a_deck_desktop/app/deck/deck_view_model.dart';
import 'package:a_deck_desktop/app/models/command.dart';
import 'package:a_deck_desktop/app/models/settings.dart';
import 'package:a_deck_desktop/services/shared_preferences_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// final dataApiProvider = Provider.autoDispose<DataApi>((ref) {
//   final settings = ref.watch(sharedPreferencesServiceProvider);
//   return DataApi(settings: settings.getSettings());
// });

final dataProvider = Provider<DataApi>((ref) {
  final settings = ref.watch(sharedPreferencesServiceProvider);
  final data = ref.read(sharedPreferencesServiceProvider).getCommandsList();
  return DataApi(
    data,
    settings: settings.getSettings(),
    ref: ref,
  );
});

class DataApi {
  final Settings settings;
  final Ref ref;
  DataApi(this.listCommand, {required this.ref, required this.settings});

  final List<Command> listCommand;
  //  = [
  //   Command(
  //       id: "1",
  //       name: "Discord",
  //       command: "C:/discord.exe",
  //       picture: 'C:/Users/obaid/Pictures/download.png'),
  //   Command(
  //       id: "2",
  //       name: "chrome",
  //       command: "C:/chrome.exe",
  //       picture: 'C:/Users/obaid/Pictures/Google_Chrome_icon_(2011).png'),
  // ];

  // get listCommand =>
  //     // ref.read(sharedPreferencesServiceProvider).getCommandsList();
  //     _listCommand;

  Future<List<Command>> apiGetCommands() {
    return Future.delayed(const Duration(milliseconds: 1000), () async {
      // return ref.read(sharedPreferencesServiceProvider).getCommandsList();
      return listCommand;
    });
  }

  List<Command> allCommands() {
    // return ref.read(sharedPreferencesServiceProvider).getCommandsList();
    return listCommand;
  }
  // void printData() {
  //   print(settings.serverPort);
  // }

  // setCommandsList() {
  //   ref.read(sharedPreferencesServiceProvider).setCommandsList(_listCommand);
  // }

  void addCommand(String name, String command, String picture) {
    listCommand.add(
      Command(
          id: (listCommand.length + 1).toString(),
          name: name,
          command: command,
          picture: picture),
    );
    print(listCommand);
    ref.read(sharedPreferencesServiceProvider).setCommandsList(listCommand);
    // ref.refresh(deckCommandProvider);
    // ref.refresh(commandsListProvider);
  }

  void deleteCommand(String id) {
    listCommand.removeAt(int.parse(id) - 1);
    ref.read(sharedPreferencesServiceProvider).setCommandsList(listCommand);
  }
}
