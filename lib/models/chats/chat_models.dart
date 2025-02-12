import 'package:chats/models/chats/files_models.dart';
import 'package:chats/models/profile/user_model.dart';
import 'package:chats/utils/json_utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_models.g.dart';

extension ChatModelsExtension on ChatModels {
  bool get hasNext => ((listMessages?.length ?? 0)) < (totalPage ?? 0);
}

@JsonSerializable()
class ChatModels {
  ChatData? chat;

  @JsonKey(name: 'listMessages')
  List<Message>? listMessages;

  @JsonKey(fromJson: parseToInt)
  int? totalPage;

  @JsonKey(fromJson: parseToInt)
  int? totalCount;

  @JsonKey(fromJson: parseToInt)
  int? page;

  @JsonKey(fromJson: parseToInt)
  int? size;

  ChatModels({
    this.chat,
    this.listMessages,
    this.totalPage,
    this.totalCount,
    this.page,
    this.size,
  });

  factory ChatModels.fromJson(Map<String, dynamic> json) => _$ChatModelsFromJson(json);
  Map<String, dynamic> toJson() => _$ChatModelsToJson(this);

  ChatModels copyWith({
    ChatData? chat,
    List<Message>? listMessages,
    int? totalPage,
    int? totalCount,
    int? page,
    int? size,
  }) {
    return ChatModels(
      chat: chat ?? this.chat,
      listMessages: listMessages ?? this.listMessages,
      totalPage: totalPage ?? this.totalPage,
      totalCount: totalCount ?? this.totalCount,
      page: page ?? this.page,
      size: size ?? this.size,
    );
  }
}

@JsonSerializable()
class ChatData {
  int? id;
  String? name;
  UserModel? owner;

  @JsonKey(name: 'is_group')
  int? isGroup;

  List<UserModel>? users;

  @JsonKey(name: 'latest_message')
  Message? latestMessage;

  @JsonKey(name: 'created_at')
  String? createdAt;

  ChatData({
    this.id,
    this.name,
    this.owner,
    this.isGroup,
    this.users,
    this.latestMessage,
    this.createdAt,
  });

  factory ChatData.fromJson(Map<String, dynamic> json) => _$ChatDataFromJson(json);
  Map<String, dynamic> toJson() => _$ChatDataToJson(this);
}

@JsonSerializable()
class Message {
  int? id;
  String? message;
  UserModel? sender;

  @JsonKey(name: 'chat_id')
  int? chatId;

  List<FilesModels>? files;

  @JsonKey(name: 'is_rollback')
  bool? isRollback;

  @JsonKey(name: 'created_at')
  String? createdAt;

  Message({
    this.id,
    this.message,
    this.sender,
    this.chatId,
    this.files,
    this.isRollback,
    this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);
  Map<String, dynamic> toJson() => _$MessageToJson(this);
}
