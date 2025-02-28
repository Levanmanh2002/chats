import 'package:chats/models/chats/chat_data_model.dart';

class GroupOptionParameter {
  final ChatDataModel? chat;
  final bool isHideMessage;

  GroupOptionParameter({this.chat, required this.isHideMessage});
}
