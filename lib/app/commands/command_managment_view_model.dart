import 'dart:io';

import 'package:a_deck_desktop/app/models/command.dart';
import 'package:a_deck_desktop/services/data_api.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final addCommandViewModel =
    StateNotifierProvider<CommandManagmentViewModel, Command>((
  ref,
) {
  return CommandManagmentViewModel(ref, null);
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
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      File file = File(result.files.single.path!);
      picture = file.path;
      state = Command(id: id, name: name, command: command, picture: picture);
    } else {
      // User canceled the picker
    }
  }

  void appSelection(String name) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);
      command = file.path;
      state = Command(id: id, name: name, command: command, picture: picture);
    } else {
      // User canceled the picker
    }
  }

  void onSubmitNew(BuildContext context) {
    ref.read(dataProvider.notifier).addCommand(state);
    Navigator.pop(context);
  }

  void onSubmitModify(BuildContext context) {
    ref.read(dataProvider.notifier).editCommand(state);
    Navigator.pop(context);
  }
}
