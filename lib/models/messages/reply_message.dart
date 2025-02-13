import 'package:chats/models/messages/files_models.dart';
import 'package:chats/models/profile/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reply_message.g.dart';

@JsonSerializable()
class ReplyMessage {
  int? id;
  String? message;
  UserModel? sender;

  @JsonKey(name: 'chat_id')
  int? chatId;

  List<FilesModels>? files;

  @JsonKey(name: 'created_at')
  String? createdAt;

  ReplyMessage({
    this.id,
    this.message,
    this.sender,
    this.chatId,
    this.files,
    this.createdAt,
  });

  factory ReplyMessage.fromJson(Map<String, dynamic> json) => _$ReplyMessageFromJson(json);
  Map<String, dynamic> toJson() => _$ReplyMessageToJson(this);
}
