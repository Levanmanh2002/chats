import 'package:chats/models/messages/message_data_model.dart';
import 'package:chats/models/profile/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_data_model.g.dart';

@JsonSerializable()
class ChatDataModel {
  int? id;
  String? name;
  UserModel? owner;

  @JsonKey(name: 'is_group')
  int? isGroup;

  List<UserModel>? users;

  @JsonKey(name: 'latest_message')
  MessageDataModel? latestMessage;

  @JsonKey(name: 'created_at')
  String? createdAt;

  ChatDataModel({
    this.id,
    this.name,
    this.owner,
    this.isGroup,
    this.users,
    this.latestMessage,
    this.createdAt,
  });

  factory ChatDataModel.fromJson(Map<String, dynamic> json) => _$ChatDataModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChatDataModelToJson(this);
}
