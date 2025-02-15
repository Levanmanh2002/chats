import 'package:chats/models/profile/user_model.dart';

enum CreateGroupType { createGroup, joinGroup }

class CreateGroupParameter {
  final CreateGroupType type;
  final List<UserModel>? users;

  CreateGroupParameter({required this.type, this.users});
}
