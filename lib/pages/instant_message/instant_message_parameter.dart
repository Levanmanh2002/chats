enum InstantMessageType { chat, group }

class InstantMessageParameter {
  final int chatId;
  final InstantMessageType type;

  InstantMessageParameter({required this.chatId, required this.type});
}
