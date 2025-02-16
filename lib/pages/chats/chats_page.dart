import 'package:chats/pages/chats/chats_controller.dart';
import 'package:chats/pages/chats/view/chat_all_view.dart';
import 'package:chats/pages/chats/view/header_chat_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatsPage extends GetWidget<ChatsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderChatView(),
          Expanded(child: ChatAllView()),
        ],
      ),
    );
  }
}
