import 'package:chats/models/profile/user_model.dart';

enum EnterCodeMumberAction { enable, disable, change }

class EnterCodeMumberParameter {
  final UserModel? user;
  final EnterCodeMumberAction action;

  EnterCodeMumberParameter({required this.user, required this.action});
}
