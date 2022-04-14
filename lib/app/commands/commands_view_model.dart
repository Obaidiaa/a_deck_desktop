import 'dart:io';

import 'package:a_deck_desktop/app/deck/deck_view_model.dart';
import 'package:a_deck_desktop/app/models/command.dart';
import 'package:a_deck_desktop/services/data_api.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final commandsViewModelProvider = Provider((ref) {
  final dataApi = ref.watch(dataProvider);
  return CommandsViewModel(dataApi: dataApi, ref: ref);
});

final commandsListProvider = Provider<List<Command>>((ref) {
  final dataApi = ref.watch(dataProvider);
  print('commandListProvider called');
  return dataApi.allCommands();
});

// final addCommandProvider =
//     StateNotifierProvider<AddCommandViewModel, Command>((ref) {
//   final dataApi = ref.watch(dataProvider);
//   return AddCommandViewModel(dataApi, ref);
// });

class CommandsViewModel extends StateNotifier<List<Command>> {
  CommandsViewModel({required this.dataApi, required this.ref}) : super([]);
  final DataApi dataApi;
  final Ref ref;
  // CommandsViewModel({required this.dataApi}) : super([]);
  String? picture;
  String name = '';
  String command = '';
  String id = '';

  onDeleteCommand(String id) {
    dataApi.deleteCommand(id);
  }
}

final addCommandProvider =
    StateNotifierProvider<AddCommandViewModel, Command>((ref) {
  final dataApi = ref.watch(dataProvider);
  return AddCommandViewModel(dataApi, ref);
});

class AddCommandViewModel extends StateNotifier<Command> {
  AddCommandViewModel(this.dataApi, this.ref)
      : super(Command(id: '', name: '', command: '', picture: null));

  String? picture;
  String name = '';
  String command = '';
  String id = '';
  final DataApi dataApi;
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

  void onSubmit(String name, String command, BuildContext context) {
    ref.read(dataProvider).addCommand(name, command, picture!);
    // dataApi.addCommand(name, command, picture!);
    Navigator.pop(context);
  }
}
