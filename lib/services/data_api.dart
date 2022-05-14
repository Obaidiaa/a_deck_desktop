// send data to client

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:a_deck_desktop/app/models/command.dart';
import 'package:a_deck_desktop/app/models/settings.dart';
import 'package:a_deck_desktop/services/shared_preferences_service.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

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
    httpServer();
  }

  ServerSocket? server;
  Socket? socket;
  List<Command>? listCommands;
  bool isWebSocketRunning = false;
  WebSocket? webSocket;
  var uuid = const Uuid();

  @override
  List<Command> get state => super.state;

  List<Command> apiGetCommands() {
    return state;
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
          id: newCommand.id,
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

  startServer() async {
    // bind the socket server to an address and port
    if (isWebSocketRunning) {
      if (kDebugMode) {
        print(isWebSocketRunning);
      }
      return;
    }
    final server = await ServerSocket.bind(
        InternetAddress.anyIPv4, int.parse(settings.serverPort));
    isWebSocketRunning = true;
    if (kDebugMode) {
      print('server started');
    }
    // listen for clent connections to the server
    server.listen((client) {
      socket = client;
      handleConnection(client);
    });
  }

  httpServer() async {
    HttpServer.bind(InternetAddress.anyIPv4, int.parse(settings.serverPort) + 1)
        .then((server) {
      server.listen((HttpRequest request) {
        try {
          if (request.method == 'GET') {
            String? imageID = request.uri.queryParameters['ImageID'];
            final imageLocation =
                state.firstWhere((element) => element.id == imageID).picture!;
            File image = File(imageLocation);
            image.readAsBytes().then((raw) {
              request.response.headers.set('Content-Type', 'image/jpeg');
              request.response.headers.set('Content-Length', raw.length);
              request.response.add(raw);
              request.response.close();
            });
          } else {}
        } catch (e) {
          if (kDebugMode) {
            print('Exception in handleRequest: $e');
          }
        }
        if (kDebugMode) {
          print('Request handled.');
        }
      });
    });
  }

  void handleConnection(Socket client) {
    if (kDebugMode) {
      print('Connection from'
          ' ${client.remoteAddress.address}:${client.remotePort}');
    }
    final commandsListJson = jsonEncode(state.map((e) => e.toJson()).toList());

    // listen for events from the client
    client.listen(
      // handle data from the client
      (Uint8List data) async {
        final message = String.fromCharCodes(data);
        try {
          final command = jsonDecode(message)['command'];
          final parameters = jsonDecode(message)['parameters'];
          if (command == 'getCommandsList') {
            client.write(commandsListJson);
          } else if (command == 'StartApplication') {
            if (kDebugMode) {
              print('Start Command Request');
            }
            if (kDebugMode) {
              print(' ${jsonDecode(message)['parameters']}');
            }
            final command =
                state.firstWhere((element) => element.id == parameters).command;
            if (kDebugMode) {
              print(command);
            }
            await Process.start('powershell "$command"', [], runInShell: false);
          } else {
            client.write('I don\'t not this command');
          }
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
        }
      },

      // handle errors
      onError: (error) {
        isWebSocketRunning = false;
        if (kDebugMode) {
          print(error);
        }
        client.close();
      },

      // handle the client closing the connection
      onDone: () {
        isWebSocketRunning = false;
        if (kDebugMode) {
          print('Client left');
        }
        client.close();
      },
    );
  }

  sendMessage(String message) async {
    if (kDebugMode) {
      print('Client: $message');
    }
    if (socket != null) {
      socket!.write(message);
    } else {
      if (kDebugMode) {
        print('no client ocnnected');
      }
    }
  }

  sendMessageWebSocket(String message) async {
    if (kDebugMode) {
      print('Client: $message');
    }
    if (webSocket != null) {
      webSocket!.add(message);
    } else {
      if (kDebugMode) {
        print('no client ocnnected');
      }
    }
  }
}
