// load data from server

import 'package:a_deck_desktop/app/models/command.dart';
import 'package:a_deck_desktop/app/models/settings.dart';
import 'package:a_deck_desktop/services/shared_preferences_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dataProvider = StateNotifierProvider<DataApi, List<Command>>((ref) {
  final settings = ref.watch(sharedPreferencesServiceProvider);
  final data = ref.read(sharedPreferencesServiceProvider).getCommandsList();
  return DataApi(
    data,
    settings: settings.getSettings(),
    ref: ref,
  );
});

class DataApi extends StateNotifier<List<Command>> {
  final Settings settings;
  final Ref ref;
  DataApi(this.listCommands, {required this.ref, required this.settings})
      : super(listCommands ?? []);

  List<Command>? listCommands;

  @override
  List<Command> get state => super.state;

  Future<List<Command>> apiGetCommands() {
    return Future.delayed(const Duration(milliseconds: 1000), () async {
      return state;
    });
  }

  void setCommands(String id) {
    state = state.where((element) => element.id != id).toList();
    ref.read(sharedPreferencesServiceProvider).setCommandsList(state);
  }

  void addCommand(Command newCommand) {
    state = [
      ...state,
      Command(
          id: (listCommands!.length + 1).toString(),
          name: newCommand.name,
          command: newCommand.command,
          picture: newCommand.picture),
    ];
    ref.read(sharedPreferencesServiceProvider).setCommandsList(state);
  }

  void editCommand(Command modifiedCommand) {
    state = [
      for (final command in state)
        if (command.id == modifiedCommand.id)
          Command(
              id: modifiedCommand.id,
              name: modifiedCommand.name,
              command: modifiedCommand.command,
              picture: modifiedCommand.picture)
        else
          command
    ];
    ref.read(sharedPreferencesServiceProvider).setCommandsList(state);
  }

  void deleteCommand(String id) {
    state = state.where((element) => element.id != id).toList();
    ref.read(sharedPreferencesServiceProvider).setCommandsList(state);
  }
}
