// class for local data storage eg. settings

import 'dart:convert';

import 'package:a_deck_desktop/app/models/command.dart';
import 'package:a_deck_desktop/app/models/settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesServiceProvider =
    Provider<SharedPreferencesService>((ref) => throw UnimplementedError());

class SharedPreferencesService {
  // late final SharedPreferences sharedPreferences;

  SharedPreferencesService(this.sharedPreferences);

  final SharedPreferences sharedPreferences;

// server ip sharedPref
  static const serverIp = 'serverIp';
// server port shardPref
  static const serverPort = 'serverPort';

  static const commandsListKey = 'commands';

  setSettings(String ip, String port) async {
    await sharedPreferences.setString(serverIp, ip);
    await sharedPreferences.setString(serverPort, port);
  }

  setCommandsList(List<Command> commandsList) async {
    // final commandsJson = jsonEncode(commandsList);
    var commandsJson = jsonEncode(commandsList.map((e) => e.toJson()).toList());

    // print(jsonEncode(commandsList[0]));
    await sharedPreferences.setString(commandsListKey, commandsJson);
  }

  List<Command> getCommandsList() {
    final String? commandsListJson =
        sharedPreferences.getString(commandsListKey);
    if (commandsListJson != null) {
      final List<dynamic> json = jsonDecode(commandsListJson);
      final List<Command> commandsList =
          json.map((e) => Command.fromJson(e)).toList();
      return commandsList.cast<Command>();
    } else {
      return [];
    }
  }

  Settings getSettings() {
    final serverIpPref = sharedPreferences.getString(serverIp) ?? "";
    final serverPortPref = sharedPreferences.getString(serverPort) ?? "0000";
    return Settings(serverIp: serverIpPref, serverPort: serverPortPref);
  }

  void deleteSettings() {
    // sharedPreferences.remove(serverIp);
    // sharedPreferences.remove(serverPort);
    sharedPreferences.remove(commandsListKey);
  }
}
