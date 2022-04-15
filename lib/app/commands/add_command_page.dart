import 'dart:io';

import 'package:a_deck_desktop/app/commands/command_managment_view_model.dart';
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

  onSubmit(
      WidgetRef ref, String name, String commandState, BuildContext context) {
    ref.read(addCommandViewModel.notifier).onSubmitNew(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Command commandState = ref.watch(addCommandViewModel);
    final nameTextController = TextEditingController(text: commandState.name);
    final commandTextController =
        TextEditingController(text: commandState.command);
    final pictureTextController =
        TextEditingController(text: commandState.picture);
    // File? pictureFile = commandState.picture;
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
                            value != null ? null : "Name can't be empty",
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
                              commandState.command = commandTextController.text,
                          validator: (value) =>
                              value != null ? null : "Command can't be empty",
                        ),
                      ),
                      SizedBox(
                        width: 150,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            ref
                                .read(addCommandViewModel.notifier)
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
                              const InputDecoration(label: Text('Picture')),
                          validator: (value) =>
                              value != null ? null : "Picture can't be empty",
                        ),
                      ),
                      SizedBox(
                        width: 150,
                        height: 50,
                        child: ElevatedButton(
                            onPressed: () => ref
                                .read(addCommandViewModel.notifier)
                                .pickPicture(nameTextController.text,
                                    commandTextController.text),
                            child: const Text('Select Picture')),
                      ),
                    ],
                  ),
                  if (commandState.picture != null)
                    Image.file(
                      File(commandState.picture!),
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
