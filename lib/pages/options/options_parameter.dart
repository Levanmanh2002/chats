import 'package:chats/models/profile/user_model.dart';

class OptionsParameter {
  final UserModel? user;
  final int chatId;
  final bool isHideMessage;
  final bool isCheckUserLocal;

  OptionsParameter({
    this.user,
    required this.chatId,
    required this.isHideMessage,
    this.isCheckUserLocal = false,
  });
}
