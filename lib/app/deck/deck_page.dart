// deck page showing all commands

import 'dart:io';

import 'package:a_deck_desktop/app/deck/deck_view_model.dart';
import 'package:a_deck_desktop/app/models/settings.dart';
import 'package:a_deck_desktop/routing/app_router.dart';
import 'package:a_deck_desktop/services/shared_preferences_service.dart';
import 'package:a_deck_desktop/services/web_socket_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeckPage extends ConsumerStatefulWidget {
  const DeckPage({Key? key}) : super(key: key);

  static Future<void> show(BuildContext context, {Settings? settings}) async {
    await Navigator.of(context, rootNavigator: true).pushNamed(
      AppRoutes.deckPage,
      arguments: settings,
    );
  }

  @override
  _DeckPageState createState() => _DeckPageState();
}

class _DeckPageState extends ConsumerState<DeckPage> {
  @override
  Widget build(BuildContext context) {
    return const DeckDisplay();
  }
}

class DeckDisplay extends ConsumerWidget {
  const DeckDisplay({Key? key}) : super(key: key);

  onAdd(WidgetRef ref) {
    ref.read(deckViewModelProvider.notifier).addCommand();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Expanded(
            child: ref.watch(deckCommandProvider).when(
                data: (data) => GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          child: InkWell(
                            onTap: () => ref
                                .read(webSocketServiceProvider.notifier)
                                .start(),
                            child: Image.file(File(data[index].picture!),
                                fit: BoxFit.fill),
                          ),
                        );
                      },
                    ),
                error: (error, trace) => Text(error.toString()),
                loading: () => const SizedBox(
                      child: Center(child: CircularProgressIndicator()),
                    ))),
        ElevatedButton(
          onPressed: () =>
              ref.read(sharedPreferencesServiceProvider).deleteSettings(),
          child: const Text('re'),
        )
      ],
    );
  }
}
