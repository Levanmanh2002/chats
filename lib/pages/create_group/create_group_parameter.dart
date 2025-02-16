import 'package:chats/models/profile/user_model.dart';

enum CreateGroupType { createGroup, joinGroup }

class CreateGroupParameter {
  final CreateGroupType type;
  final int? groupId;
  final List<UserModel>? users;
  final bool? updateAddMemberLocal;

  CreateGroupParameter({required this.type, this.groupId, this.users, this.updateAddMemberLocal});
}
