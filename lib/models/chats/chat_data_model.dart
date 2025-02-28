import 'package:chats/models/messages/message_data_model.dart';
import 'package:chats/models/profile/user_model.dart';
import 'package:chats/utils/json_utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_data_model.g.dart';

@JsonSerializable()
class ChatDataModel {
  int? id;
  String? name;
  UserModel? owner;

  @JsonKey(name: 'is_group', fromJson: parseFromBoolToInt)
  int? isGroup;

  @JsonKey(name: 'is_read')
  bool? isRead;

  List<UserModel>? users;

  @JsonKey(name: 'latest_message')
  MessageDataModel? latestMessage;

  @JsonKey(name: 'is_hide', fromJson: parseToBool)
  bool? isHide;

  @JsonKey(name: 'created_at')
  String? createdAt;

  ChatDataModel({
    this.id,
    this.name,
    this.owner,
    this.isGroup,
    this.isRead,
    this.users,
    this.latestMessage,
    this.isHide,
    this.createdAt,
  });

  factory ChatDataModel.fromJson(Map<String, dynamic> json) => _$ChatDataModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChatDataModelToJson(this);

  ChatDataModel copyWith({
    int? id,
    String? name,
    UserModel? owner,
    int? isGroup,
    List<UserModel>? users,
    MessageDataModel? latestMessage,
    bool? isHide,
    String? createdAt,
  }) {
    return ChatDataModel(
      id: id ?? this.id,
      name: name ?? this.name,
      owner: owner ?? this.owner,
      isGroup: isGroup ?? this.isGroup,
      users: users ?? this.users,
      latestMessage: latestMessage ?? this.latestMessage,
      isHide: isHide ?? this.isHide,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
