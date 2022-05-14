import 'dart:io';

import 'package:a_deck_desktop/app/commands/commands_view_model.dart';
import 'package:a_deck_desktop/app/models/command.dart';
import 'package:a_deck_desktop/services/data_api.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

final addCommandViewModel =
    StateNotifierProvider<CommandManagmentViewModel, Command>((
  ref,
) {
  const uuid = Uuid();

  return CommandManagmentViewModel(
      ref, Command(id: uuid.v4(), name: '', command: '', picture: null));
});
final editCommandViewModel =
    StateNotifierProvider.family<CommandManagmentViewModel, Command, Command>(
        (ref, command) {
  return CommandManagmentViewModel(ref, command);
});

class CommandManagmentViewModel extends StateNotifier<Command> {
  CommandManagmentViewModel(this.ref, this.commandModel)
      : super(commandModel ??
            Command(id: '', name: '', command: '', picture: null));

  Command? commandModel;
  String? picture;
  String name = '';
  String command = '';
  String id = '';
  final Ref ref;

  void pickPicture(
    String name,
    String command,
  ) async {
    Directory supp = await getApplicationSupportDirectory();

    FilePickerResult? result = await FilePicker.platform
        .pickFiles(initialDirectory: '${supp.path}\\icons\\${state.id}\\');

    if (kDebugMode) {
      print('${supp.path}\\icons\\$id\\');
    }
    if (result != null) {
      File file = File(result.files.single.path!);
      picture = file.path;
      state =
          Command(id: state.id, name: name, command: command, picture: picture);
    } else {
      // User canceled the picker
    }
  }

  void appSelection(String name) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      withData: false,
      withReadStream: false,
    );
    if (result != null) {
      File file = File(result.files.single.path!);
      command = file.path;
      state =
          Command(id: state.id, name: name, command: command, picture: picture);
    } else {
      // User canceled the picker
    }
  }

  extractIcon(String filePath, String id) async {
    Directory supp = await getApplicationSupportDirectory();
    String appicationName = filePath.split('\\').last.split('.').first;
    Directory('${supp.path}\\icons\\$appicationName').create();
    String cmd =
        'C:\\Users\\obaid\\Desktop\\Projects\\a_deck_desktop\\assets\\icon_extractor\\pe_parse.exe -i "$filePath"  -o ${supp.path}\\icons\\$appicationName\\';
    await Process.start(cmd, [], runInShell: false);
  }

  void onSubmitNew(BuildContext context) {
    ref.read(dataProvider.notifier).addCommand(state);
    ref.refresh(commandsViewModelProvider);
    Navigator.pop(context);
  }

  void onSubmitModify(BuildContext context) {
    ref.read(dataProvider.notifier).editCommand(state);
    Navigator.pop(context);
  }
}
