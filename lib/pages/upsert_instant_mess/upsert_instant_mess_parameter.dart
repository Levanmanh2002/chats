import 'package:chats/models/messages/quick_message.dart';

enum UpsertInstantMessType { create, update }

class UpsertInstantMessParameter {
  final UpsertInstantMessType type;
  final int? chatId;
  final QuickMessage? quickMessage;

  UpsertInstantMessParameter({required this.type, this.chatId, this.quickMessage});
}
