// send data to client

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:a_deck_desktop/app/models/command.dart';
import 'package:a_deck_desktop/app/models/settings.dart';
import 'package:a_deck_desktop/services/shared_preferences_service.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final dataProvider = StateNotifierProvider<DataApi, List<Command>>((ref) {
  final settings = ref.watch(sharedPreferencesServiceProvider);
  final data = ref.read(sharedPreferencesServiceProvider).getCommandsList();
  return DataApi(
    data,
    settings: settings.getSettings(),
    ref: ref,
  );
});

class DataApi extends StateNotifier<List<Command>> {
  final Settings settings;
  final Ref ref;
  DataApi(this.listCommands, {required this.ref, required this.settings})
      : super(listCommands ?? []) {
    startServer();
    startServer2();
  }

  ServerSocket? server;
  Socket? socket;
  List<Command>? listCommands;
  bool isWebSocketRunning = false;

  @override
  List<Command> get state => super.state;

  List<Command> apiGetCommands() {
    // return Future.delayed(const Duration(milliseconds: 1000), () async {
    return state;
    // });
  }

  void setCommands(String id) {
    state = state.where((element) => element.id != id).toList();
    ref.read(sharedPreferencesServiceProvider).setCommandsList(state);
    final commandsListJson = jsonEncode(state.map((e) => e.toJson()).toList());

    sendMessage(commandsListJson);
  }

  void addCommand(Command newCommand) {
    state = [
      ...state,
      Command(
          id: (listCommands!.length + 1).toString(),
          name: newCommand.name,
          command: newCommand.command,
          picture: newCommand.picture!),
    ];
    ref.read(sharedPreferencesServiceProvider).setCommandsList(state);
    final commandsListJson = jsonEncode(state.map((e) => e.toJson()).toList());

    sendMessage(commandsListJson);
  }

  void editCommand(Command modifiedCommand) {
    state = [
      for (final command in state)
        if (command.id == modifiedCommand.id)
          Command(
              id: modifiedCommand.id,
              name: modifiedCommand.name,
              command: modifiedCommand.command,
              picture: modifiedCommand.picture!)
        else
          command
    ];
    ref.read(sharedPreferencesServiceProvider).setCommandsList(state);
    final commandsListJson = jsonEncode(state.map((e) => e.toJson()).toList());

    sendMessage(commandsListJson);
  }

  void deleteCommand(String id) {
    state = state.where((element) => element.id != id).toList();
    ref.read(sharedPreferencesServiceProvider).setCommandsList(state);
    final commandsListJson = jsonEncode(state.map((e) => e.toJson()).toList());

    sendMessage(commandsListJson);
  }

  // List<Socket> sockets = [];
  // StreamConsumer<String>? streamConsumer;

  startServer() async {
    // bind the socket server to an address and port
    if (isWebSocketRunning) {
      print(isWebSocketRunning);
      return;
    }
    final server = await ServerSocket.bind(InternetAddress.anyIPv4, 7777);
    isWebSocketRunning = true;
    print('server started');
    // socket = await server.first;
    // print(socket.address);
    // listen for clent connections to the server
    server.listen((client) {
      socket = client;
      handleConnection(client);
    });
  }

  startServer2() {
    HttpServer.bind(InternetAddress.anyIPv4, 8888).then((HttpServer server) {
      // httpserver listens on http://localhost:8000
      print('[+]HttpServer listening at -- http://localhost:8888');
      server.listen((HttpRequest request) {
        WebSocketTransformer.upgrade(request).then((WebSocket ws) {
          // upgradation happens here and now we've a WebSocket object
          ws.listen(
            // listening for data
            (data) async {
              print(
                  '\t\t${request.connectionInfo?.remoteAddress} -- ${Map<String, String>.from(json.decode(data))}'); // client will send JSON data

              if (ws.readyState == WebSocket.open) {
                final command = jsonDecode(data)['command'];
                final pararmeters = jsonDecode(data)['parameters'];
                if (command == 'getCommandsList') {
                  ws.add(jsonEncode(state));
                } else if (command == 'getImage') {
                  final imageId = jsonDecode(data);
                  print(state);
                  final image = state
                      .firstWhere(
                          (element) => element.id == imageId['parameters'])
                      .picture!;
                  print(image);
                  await ws.addStream(File(image).openRead());
                  // await File(image).openRead().pipe();
                }
              }
            },
            onDone: () => print('[+]Done :)'),
            onError: (err) => print('[!]Error -- ${err.toString()}'),
            cancelOnError: true,
          );
        }, onError: (err) => print('[!]Error -- ${err.toString()}'));
      }, onError: (err) => print('[!]Error -- ${err.toString()}'));
    }, onError: (err) => print('[!]Error -- ${err.toString()}'));
  }

  void handleConnection(Socket client) {
    print('Connection from'
        ' ${client.remoteAddress.address}:${client.remotePort}');
    final commandsListJson = jsonEncode(state.map((e) => e.toJson()).toList());

    // listen for events from the client
    client.listen(
      // handle data from the client
      (Uint8List data) async {
        final message = String.fromCharCodes(data);
        final command = jsonDecode(message)['command'];
        if (command == 'getCommandsList') {
          client.write(commandsListJson);
        } else if (message.contains('getImage')) {
          final imageId = jsonDecode(message);
          print(imageId);
          final image = state
              .firstWhere((element) => element.id == imageId['getImage'])
              .picture!;
          print(image);
          await File(image).openRead().pipe(client);
        } else {
          client.write('Very funny.');
        }
      },

      // handle errors
      onError: (error) {
        isWebSocketRunning = false;
        print(error);
        client.close();
      },

      // handle the client closing the connection
      onDone: () {
        isWebSocketRunning = false;
        print('Client left');
        client.close();
      },
    );
  }

  sendMessage(String message) async {
    print('Client: $message');
    if (socket != null) {
      socket!.write(message);
    } else {
      print('no client ocnnected');
    }
  }
}
