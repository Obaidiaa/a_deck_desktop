import 'dart:io';

import 'package:a_deck_desktop/app/commands/add_command.dart';
import 'package:a_deck_desktop/app/commands/commands_view_model.dart';
import 'package:a_deck_desktop/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommandsPage extends ConsumerStatefulWidget {
  const CommandsPage({Key? key}) : super(key: key);

  static Future<void> show(BuildContext context) async {
    await Navigator.of(context, rootNavigator: true).pushNamed(
      AppRoutes.commandsPage,
    );
  }

  @override
  _CommandsPageState createState() => _CommandsPageState();
}

class _CommandsPageState extends ConsumerState<CommandsPage> {
  @override
  Widget build(BuildContext context) {
    ref.watch(addCommandProvider);
    print("rebuilding");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Commands'),
        actions: [
          ElevatedButton(
              onPressed: () => showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      const Dialog(child: AddCommand()))
                ..then((val) {
                  ref.refresh(commandsViewModelProvider);
                }),
              child: const Icon(Icons.add))
        ],
      ),
      body: SafeArea(
          child: Column(
              children: ref.read(commandsListProvider).map((data) {
        return ListTile(
          title: Text(data.name!),
          leading: Image.file(File(data.picture!)),
          subtitle: Text(data.command!),
          trailing: ElevatedButton(
              child: const Text("delete command"),
              onPressed: () => ref
                  .read(commandsViewModelProvider)
                  .onDeleteCommand(data.id!)),
        );
      }).toList())),
    );
  }
}
