import 'package:chats/models/messages/quick_message.dart';

enum UpsertInstantMessType { create, update }

class UpsertInstantMessParameter {
  final UpsertInstantMessType type;
  final int chatId;
  final QuickMessage? quickMessage;

  UpsertInstantMessParameter({required this.type, required this.chatId, this.quickMessage});
}
