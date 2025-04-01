enum InstantMessageType { chat, group, noChatId }

class InstantMessageParameter {
  final int? chatId;
  final InstantMessageType type;

  InstantMessageParameter({this.chatId, required this.type});
}
