import 'package:chats/models/profile/user_model.dart';

class OptionsParameter {
  final UserModel? user;
  final int chatId;
  final bool isHideMessage;

  OptionsParameter({this.user, required this.chatId, required this.isHideMessage});
}
