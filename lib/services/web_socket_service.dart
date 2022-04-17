import 'dart:async';
import 'dart:convert';

import 'dart:io';
import 'dart:typed_data';

import 'package:a_deck_desktop/services/data_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final webSocketServiceProvider =
    StateNotifierProvider<WebSocketService, int>((ref) {
  ref.watch(dataProvider);
  return WebSocketService(0);
});

class WebSocketService extends StateNotifier<int> {
  ServerSocket? server;

  WebSocketService(int state) : super(state);

  Uint8List? onData;
  // callback onError;
  bool running = false;
  List<Socket> sockets = [];
  StreamConsumer<Uint8List>? streamConsumer;
  start() async {
    runZonedGuarded(() async {
      server = await ServerSocket.bind(InternetAddress.anyIPv4, 7777);
      print(server!.address);
      running = true;
      server?.listen(onRequest);
      onData = Uint8List.fromList('Server listening on port 4040'.codeUnits);
    }, (Object error, StackTrace stack) {
      print('$error $stack');
      server!.close();
    });
  }

  stop() async {
    await server!.close();
    server = null;
    running = false;
  }

  broadCast(String message) {
    onData = Uint8List.fromList('Broadcasting : $message'.codeUnits);
    for (Socket socket in sockets) {
      socket.write(message + '\n');
    }
  }

  onRequest(Socket socket) {
    print(socket.remoteAddress);
    if (!sockets.contains(socket)) {
      sockets.add(socket);
      socket.write("object");
      // socket.pipe(streamConsumer);
      // print(streamConsumer);
    }

    socket.listen((Uint8List data) {
      // onData = data;
      final outputAsUint8List = utf8.decode(data);
      print(outputAsUint8List);
    });
  }
}
