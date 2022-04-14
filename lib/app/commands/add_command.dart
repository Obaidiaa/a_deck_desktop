import 'dart:io';
import 'dart:ui';

import 'package:a_deck_desktop/app/commands/commands_view_model.dart';
import 'package:a_deck_desktop/app/models/command.dart';
import 'package:a_deck_desktop/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddCommand extends ConsumerWidget {
  const AddCommand({Key? key}) : super(key: key);

  static Future<void> show(BuildContext context) async {
    await Navigator.of(context, rootNavigator: true).pushNamed(
      AppRoutes.commandAddPage,
    );
  }

  onSubmit(WidgetRef ref, String name, String command, BuildContext context) {
    ref.read(addCommandProvider.notifier).onSubmit(name, command, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Command command = ref.watch(addCommandProvider);
    print(command.command);
    final nameTextController = TextEditingController(text: command.name);
    final commandTextController = TextEditingController(text: command.command);
    final pictureTextController = TextEditingController(text: command.picture);
    // File? pictureFile = command.picture;
    return SizedBox(
      height: 500,
      width: 500,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ListView(
            children: [
              const Center(
                child: Text(
                  'Add Command',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              Form(
                  child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: 350,
                      child: TextFormField(
                        controller: nameTextController,
                        decoration: const InputDecoration(labelText: 'Name'),
                        validator: (value) =>
                            value != null ? null : "can't be empty",
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 350,
                        child: TextFormField(
                          controller: commandTextController,
                          decoration:
                              const InputDecoration(labelText: 'Command'),
                          onChanged: (value) =>
                              command.command = commandTextController.text,
                        ),
                      ),
                      SizedBox(
                        width: 150,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            ref
                                .read(addCommandProvider.notifier)
                                .appSelection(nameTextController.text);
                          },
                          child: const Text("Select Application"),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 350,
                        child: TextFormField(
                            controller: pictureTextController,
                            decoration:
                                const InputDecoration(label: Text('Picture'))),
                      ),
                      SizedBox(
                        width: 150,
                        height: 50,
                        child: ElevatedButton(
                            onPressed: () => ref
                                .read(addCommandProvider.notifier)
                                .pickPicture(nameTextController.text,
                                    commandTextController.text),
                            child: const Text('Select Picture')),
                      ),
                    ],
                  ),
                  if (command.picture != null)
                    Image.file(
                      File(command.picture!),
                      height: 320,
                      width: 320,
                    )
                  else
                    const Icon(Icons.image_not_supported),
                ],
              )),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: ElevatedButton(
                onPressed: () => onSubmit(ref, nameTextController.text,
                    commandTextController.text, context),
                child: const Text('Submit')),
          )
        ],
      ),
    );
  }
}
