import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:mychat/config/app_config.dart';
import 'package:mychat/model/message_result.dart';
import 'package:web_socket_channel/io.dart';

class SocketManager {
  late IOWebSocketChannel channel;
  List<Message> messageList = [];

  ObserverList<onReceiveMessage> observerList =
      ObserverList<onReceiveMessage>();

  Future<bool> connectWithServer(String token) async {
    print("ws://bobcat-chatserver.herokuapp.com/connect");
    channel = IOWebSocketChannel.connect(
      "ws://${GetIt.instance<AppConfig>().apiHost.substring(8)}/connect",

      headers: {'Authorization': 'Bearer ${token}'},
    );

    channel.stream.listen((message) {
      // print(message);
      // print(message['id']);
      debugPrint("Get message from server: " + message.toString());
      messageList.add(Message.fromJson(json.decode(message)));

      observerList.forEach((onReceiveMessage listener) {
        listener(json.decode(message));
      });
    });

    print("Is connected to server: ${channel != null}");
    if (channel != null) {
      return true;
    }
    return false;
  }

  disconnectWithServer() async {
    channel.sink.close();
  }

  Future<bool> sendMessage(Map<String, dynamic> data) async {
    channel.sink.add(json.encode(data));
    return true;
  }

  addListener(onReceiveMessage listener) {
    if (observerList.contains(listener)) {
      return;
    }
    observerList.add(listener);
  }

  removeListener(onReceiveMessage listener) {
    observerList.remove(listener);
  }
}

typedef onReceiveMessage(Map<String, dynamic> json);
