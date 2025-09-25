import 'package:chats/models/profile/user_model.dart';

class MessageParameter {
  final int? chatId;
  final UserModel? contact;
  final bool isChatBOT;

  MessageParameter({this.chatId, this.contact, this.isChatBOT = false});
}
