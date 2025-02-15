import 'package:chats/models/profile/user_model.dart';

class MessageParameter {
  final int? chatId;
  final UserModel? contact;

  MessageParameter({this.chatId, this.contact});
}
