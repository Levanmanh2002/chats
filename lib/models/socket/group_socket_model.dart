import 'package:chats/models/chats/chat_data_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'group_socket_model.g.dart';

@JsonSerializable()
class GroupSocketModel {
  String? title;
  GroupSocketData? data;
  String? type;

  GroupSocketModel({
    this.title,
    this.data,
    this.type,
  });

  factory GroupSocketModel.fromJson(Map<String, dynamic> json) => _$GroupSocketModelFromJson(json);

  Map<String, dynamic> toJson() => _$GroupSocketModelToJson(this);
}

@JsonSerializable()
class GroupSocketData {
  ChatDataModel? chat;
  List<int>? users;
  MessageGroup? message;

  GroupSocketData({
    this.chat,
    this.users,
    this.message,
  });

  factory GroupSocketData.fromJson(Map<String, dynamic> json) => _$GroupSocketDataFromJson(json);

  Map<String, dynamic> toJson() => _$GroupSocketDataToJson(this);
}

@JsonSerializable()
class MessageGroup {
  int? id;

  @JsonKey(name: 'chat_id')
  int? chatId;

  @JsonKey(name: 'sender_id')
  int? senderId;

  String? message;

  @JsonKey(name: 'reply_message_id')
  int? replyMessageId;

  @JsonKey(name: 'has_user_removed_from_group')
  int? hasUserRemovedFromGroup;

  @JsonKey(name: 'has_user_added_to_group')
  int? hasUserAddedToGroup;

  @JsonKey(name: 'updated_at')
  String? updatedAt;

  @JsonKey(name: 'created_at')
  String? createdAt;

  MessageGroup({
    this.id,
    this.chatId,
    this.senderId,
    this.message,
    this.replyMessageId,
    this.hasUserRemovedFromGroup,
    this.hasUserAddedToGroup,
    this.updatedAt,
    this.createdAt,
  });

  factory MessageGroup.fromJson(Map<String, dynamic> json) => _$MessageGroupFromJson(json);

  Map<String, dynamic> toJson() => _$MessageGroupToJson(this);
}
