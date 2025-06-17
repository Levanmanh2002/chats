import 'dart:async';
import 'dart:developer';

import 'package:chats/pages/profile/profile_controller.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  SocketService._internal();
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;

  late IO.Socket socket;

  StreamController streamController = StreamController.broadcast();
  Stream get stream => streamController.stream;

  Future<void> initSocket() async {
    int? userId = Get.find<ProfileController>().user.value?.id;

    if (userId == null || userId == 0) return;

    socket = IO.io(
      'https://socket-server.nhattao.tech',
      IO.OptionBuilder().setTransports(['websocket']).disableAutoConnect().build(),
    );

    socket.onConnect((_) {
      // socket.emit('join', 'app-chat-$userId');
      socket.emit('join', 'app-chat-$userId');
      log('Socket connected: ${socket.id}', name: 'SocketService');
      log('Socket connected: app-chat-$userId', name: 'SocketService');
    });

    socket.on('app-chat', (data) {
      streamController.add(data);
      // log('Received data: $data', name: 'SocketService');
    });

    socket.on(
      'connect_error',
      (err) => {
        log('Connection error: $err', name: 'SocketService'),
      },
    );

    socket.onConnectError((err) {
      print('Connection error: $err');
    });

    socket.connect();
  }

  void disconnect() {
    if (socket.connected) {
      socket.disconnect();
      log('Socket disconnected', name: 'SocketService');
    }
  }
}
