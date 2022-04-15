import 'package:a_deck_desktop/app/models/command.dart';
import 'package:a_deck_desktop/services/data_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final deckCommandProvider = FutureProvider<List<Command>>((ref) {
  ref.watch(dataProvider);
  return ref.read(dataProvider.notifier).apiGetCommands();
});

final deckViewModelProvider =
    StateNotifierProvider<DeckViewModel, List<Command>>((ref) {
  final commandsList = ref.watch(dataProvider);
  return DeckViewModel(commandsList: commandsList, ref: ref);
});

class DeckViewModel extends StateNotifier<List<Command>> {
  DeckViewModel({required this.commandsList, required this.ref})
      : super(commandsList ?? []);
  final List<Command>? commandsList;
  final Ref ref;

  @override
  get state => super.state;
  // getCommands() {
  //   // state = await dataApi.apiGetCommands();
  //   // state = dataApi.state;
  //   // ref.refresh(deckCommandProvider);
  //   // return dataApi.apiGetCommands();
  // }

  addCommand() {
    // dataApi.addCommand();
    // print(dataApi.listCommand.length);
    // state = dataApi.state;
    // ref.refresh(deckCommandProvider);
  }
}
