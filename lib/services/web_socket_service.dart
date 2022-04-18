import 'dart:async';
import 'dart:convert';

import 'dart:io';
import 'dart:typed_data';

import 'package:a_deck_desktop/app/models/command.dart';
import 'package:a_deck_desktop/services/data_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final webSocketServiceProvider =
    StateNotifierProvider<WebSocketService, bool>((ref) {
  ref.watch(dataProvider);
  return WebSocketService(false, []);
});

final webSocketServiceUpdateProvider = Provider(((ref) {
  final commandsList = ref.watch(dataProvider);
  final commandsListJson =
      jsonEncode(commandsList.map((e) => e.toJson()).toList());
  ref.read(webSocketServiceProvider.notifier).sendMessage('');
}));

class WebSocketService extends StateNotifier<bool> {
  ServerSocket? server;
  Socket? socket;
  final List<Command> commandList;
  WebSocketService(bool state, this.commandList) : super(state) {
    print('dddddddddddd');
    startServer();
  }

  bool isWebSocketRunning = false;
  // List<Socket> sockets = [];
  // StreamConsumer<String>? streamConsumer;

  startServer() async {
    // bind the socket server to an address and port
    if (isWebSocketRunning) {
      print(isWebSocketRunning);
      return;
    }
    final server =
        await ServerSocket.bind(InternetAddress.anyIPv4, 7777, shared: true);
    isWebSocketRunning = true;
    state = true;
    print('server started');
    // listen for clent connections to the server
    server.listen((client) {
      handleConnection(client);
    });
  }

  void handleConnection(Socket client) {
    socket = client;
    print('Connection from'
        ' ${client.remoteAddress.address}:${client.remotePort}');
    final commandsListJson =
        jsonEncode(commandList.map((e) => e.toJson()).toList());

    // listen for events from the client
    client.listen(
      // handle data from the client
      (Uint8List data) async {
        // await Future.delayed(Duration(seconds: 1));
        final message = String.fromCharCodes(data);
        if (message == 'getCommandsList') {
          client.write(commandsListJson);
        } else if (message.length < 10) {
          client.write('$message who?');
        } else {
          client.write('Very funny.');
          // client.close();
        }
      },

      // handle errors
      onError: (error) {
        isWebSocketRunning = false;
        state = false;
        print(error);
        client.close();
      },

      // handle the client closing the connection
      onDone: () {
        isWebSocketRunning = false;
        state = false;
        print('Client left');
        client.close();
      },
    );
  }

  sendMessage(String message) async {
    print('Client: $message');
    socket!.write(message);
  }
}
