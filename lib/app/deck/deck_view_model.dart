import 'package:a_deck_desktop/app/models/command.dart';
import 'package:a_deck_desktop/app/models/settings.dart';
import 'package:a_deck_desktop/app/top_level_providers.dart';
import 'package:a_deck_desktop/services/data_api.dart';
import 'package:a_deck_desktop/services/shared_preferences_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final deckCommandProvider = FutureProvider<List<Command>>((ref) {
  final dataApi = ref.watch(dataProvider);
  return dataApi.apiGetCommands();
});

final deckViewModelProvider = Provider((ref) {
  final dataApi = ref.watch(dataProvider);
  return DeckViewModel(dataApi: dataApi, ref: ref);
});

class DeckViewModel extends StateNotifier<List<Command>> {
  DeckViewModel({required this.dataApi, required this.ref}) : super([]) {
    getCommands();
  }
  final DataApi dataApi;
  final ProviderRef ref;
  getCommands() {
    // state = await dataApi.apiGetCommands();
    state = dataApi.listCommand;
    ref.refresh(deckCommandProvider);
    // return dataApi.apiGetCommands();
  }

  addCommand() {
    // dataApi.addCommand();
    // print(dataApi.listCommand.length);
    state = dataApi.listCommand;
    ref.refresh(deckCommandProvider);
  }
}
