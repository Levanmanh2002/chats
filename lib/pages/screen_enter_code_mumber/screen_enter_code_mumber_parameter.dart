import 'package:chats/models/profile/user_model.dart';

enum ScreenEnterCodeMumberAction { enable, disable, change }

class ScreenEnterCodeMumberParameter {
  final UserModel? user;
  final ScreenEnterCodeMumberAction action;

  ScreenEnterCodeMumberParameter({required this.user, required this.action});
}
