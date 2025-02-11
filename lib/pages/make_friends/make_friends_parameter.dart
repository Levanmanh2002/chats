import 'package:chats/models/profile/user_model.dart';

enum MakeFriendsType { add, friend }

class MakeFriendsParameter {
  final int id;
  final UserModel? contact;
  final MakeFriendsType type;

  MakeFriendsParameter({required this.id, required this.contact, required this.type});
}
