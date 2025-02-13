import 'package:chats/models/messages/files_models.dart';
import 'package:chats/models/messages/reply_message.dart';
import 'package:chats/models/profile/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message_data_model.g.dart';

enum MessageStatus { success, sending, failed }

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

  @JsonKey(name: 'reply_message')
  ReplyMessage? replyMessage;

  @JsonKey(name: 'created_at')
  String? createdAt;

  @JsonKey(ignore: true) // ✅ Bỏ qua khi parse JSON từ API
  MessageStatus status;

  MessageDataModel({
    this.id,
    this.message,
    this.sender,
    this.chatId,
    this.files,
    this.isRollback,
    this.replyMessage,
    this.createdAt,
    this.status = MessageStatus.success,
  });

  factory MessageDataModel.fromJson(Map<String, dynamic> json) {
    return _$MessageDataModelFromJson(json)..status = MessageStatus.success;
  }

  Map<String, dynamic> toJson() => _$MessageDataModelToJson(this);

  MessageDataModel copyWith({
    int? id,
    String? message,
    UserModel? sender,
    int? chatId,
    List<FilesModels>? files,
    bool? isRollback,
    ReplyMessage? replyMessage,
    String? createdAt,
    MessageStatus? status,
  }) {
    return MessageDataModel(
      id: id ?? this.id,
      message: message ?? this.message,
      sender: sender ?? this.sender,
      chatId: chatId ?? this.chatId,
      files: files ?? this.files,
      isRollback: isRollback ?? this.isRollback,
      replyMessage: replyMessage ?? this.replyMessage,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }
}
