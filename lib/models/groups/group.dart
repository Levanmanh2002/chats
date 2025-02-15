import 'package:chats/models/messages/message_data_model.dart';
import 'package:chats/models/profile/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'group.g.dart';

@JsonSerializable()
class GroupModel {
  int? id;

  @JsonKey(name: 'group_name')
  String? groupName;

  @JsonKey(name: 'group_users')
  List<UserModel>? groupUsers;

  @JsonKey(name: 'latest_message')
  MessageDataModel? latestMessage;

  @JsonKey(name: 'created_at')
  String? createdAt;

  GroupModel({
    this.id,
    this.groupName,
    this.groupUsers,
    this.latestMessage,
    this.createdAt,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) => _$GroupModelFromJson(json);

  Map<String, dynamic> toJson() => _$GroupModelToJson(this);
}
