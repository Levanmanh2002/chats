import 'package:chats/models/groups/group.dart';

class GroupMessageParameter {
  final GroupModel? groupModel;
  final int? chatId;

  GroupMessageParameter({this.groupModel, this.chatId});
}
