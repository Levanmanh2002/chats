import 'package:chats/models/chats/chat_data_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pusher_group_message.g.dart';

@JsonSerializable()
class PusherGroupMessageModel {
  @JsonKey(name: 'user_id')
  int? userId;

  Payload? payload;

  PusherGroupMessageModel({
    this.userId,
    this.payload,
  });

  factory PusherGroupMessageModel.fromJson(Map<String, dynamic> json) => _$PusherGroupMessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$PusherGroupMessageModelToJson(this);
}

@JsonSerializable()
class Payload {
  String? title;
  PayloadData? data;
  String? type;

  Payload({
    this.title,
    this.data,
    this.type,
  });

  factory Payload.fromJson(Map<String, dynamic> json) => _$PayloadFromJson(json);

  Map<String, dynamic> toJson() => _$PayloadToJson(this);
}

@JsonSerializable()
class PayloadData {
  ChatDataModel? chat;
  List<int>? users;
  PayloadMessageGroup? message;

  PayloadData({
    this.chat,
    this.users,
    this.message,
  });

  factory PayloadData.fromJson(Map<String, dynamic> json) => _$PayloadDataFromJson(json);

  Map<String, dynamic> toJson() => _$PayloadDataToJson(this);
}

@JsonSerializable()
class PayloadMessageGroup {
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

  PayloadMessageGroup({
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

  factory PayloadMessageGroup.fromJson(Map<String, dynamic> json) => _$PayloadMessageGroupFromJson(json);

  Map<String, dynamic> toJson() => _$PayloadMessageGroupToJson(this);
}
