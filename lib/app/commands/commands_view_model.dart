import 'package:a_deck_desktop/app/models/command.dart';
import 'package:a_deck_desktop/services/data_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final commandsViewModelProvider = Provider<CommandsViewModel>((ref) {
  final commandsList = ref.watch(dataProvider);
  return CommandsViewModel(commandList: commandsList, ref: ref);
});

final commandsListProvider = Provider<List<Command>>((ref) {
  final commandsList = ref.watch(dataProvider);
  return commandsList;
});

class CommandsViewModel {
  CommandsViewModel({required this.commandList, required this.ref}) : super();
  List<Command>? commandList;
  final Ref ref;
  String? picture;
  String name = '';
  String command = '';
  String id = '';

  test() async {}

  onDeleteCommand(String id) {
    ref.read(dataProvider.notifier).setCommands(id);
  }
}
