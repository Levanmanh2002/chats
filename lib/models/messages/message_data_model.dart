import 'package:chats/models/messages/files_models.dart';
import 'package:chats/models/profile/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message_data_model.g.dart';

@JsonSerializable()
class MessageDataModel {
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

  MessageDataModel({
    this.id,
    this.message,
    this.sender,
    this.chatId,
    this.files,
    this.isRollback,
    this.createdAt,
  });

  factory MessageDataModel.fromJson(Map<String, dynamic> json) => _$MessageDataModelFromJson(json);
  Map<String, dynamic> toJson() => _$MessageDataModelToJson(this);
}
