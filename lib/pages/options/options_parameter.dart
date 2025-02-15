import 'package:chats/models/profile/user_model.dart';

class OptionsParameter {
  final UserModel? user;
  final int chatId;

  OptionsParameter({this.user, required this.chatId});
}
