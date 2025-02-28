import 'package:chats/models/messages/files_models.dart';
import 'package:chats/models/messages/likes.dart';
import 'package:chats/models/messages/reply_message.dart';
import 'package:chats/models/profile/user_model.dart';
import 'package:chats/models/tickers/tickers_model.dart';
import 'package:chats/utils/json_utils.dart';
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

  @JsonKey(name: 'has_user_added_to_group')
  bool? hasUserAddedToGroup;

  @JsonKey(name: 'has_user_removed_from_group')
  bool? hasUserRemovedFromGroup;

  @JsonKey(name: 'has_user_left_group')
  bool? hasUserLeftGroup;

  @JsonKey(name: 'reply_message')
  ReplyMessage? replyMessage;

  List<LikeModel>? likes;

  TickersModel? sticker;

  @JsonKey(name: 'created_at')
  String? createdAt;

  @JsonKey(ignore: true) // ✅ Bỏ qua khi parse JSON từ API
  MessageStatus status;

  @JsonKey(name: 'is_call')
  bool? isCall;

  @JsonKey(name: 'missed_call')
  bool? missedCall;

  @JsonKey(name: 'is_dont_pick_up')
  bool? isDontPickUp;

  @JsonKey(name: 'is_reject_call_id', fromJson: parseToInt)
  int? isRejectCallId;

  @JsonKey(name: 'is_canceld_id', fromJson: parseToInt)
  int? isCanceldId;

  @JsonKey(name: 'call_started_at')
  String? callStartedAt;

  @JsonKey(name: 'call_joined_at')
  String? callJoinedAt;

  @JsonKey(name: 'call_end_at')
  String? callEndAt;

  MessageDataModel({
    this.id,
    this.message,
    this.sender,
    this.chatId,
    this.files,
    this.sticker,
    this.isRollback,
    this.hasUserAddedToGroup,
    this.hasUserRemovedFromGroup,
    this.hasUserLeftGroup,
    this.replyMessage,
    this.likes,
    this.createdAt,
    this.status = MessageStatus.success,
    this.isCall,
    this.missedCall,
    this.isDontPickUp,
    this.isRejectCallId,
    this.isCanceldId,
    this.callStartedAt,
    this.callJoinedAt,
    this.callEndAt,
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
    TickersModel? sticker,
    bool? isRollback,
    ReplyMessage? replyMessage,
    List<LikeModel>? likes,
    String? createdAt,
    MessageStatus? status,
    bool? isCall,
    bool? missedCall,
    int? isRejectCallId,
    int? isCanceldId,
    String? callStartedAt,
    String? callJoinedAt,
    String? callEndAt,
  }) {
    return MessageDataModel(
      id: id ?? this.id,
      message: message ?? this.message,
      sender: sender ?? this.sender,
      chatId: chatId ?? this.chatId,
      files: files ?? this.files,
      sticker: sticker ?? this.sticker,
      isRollback: isRollback ?? this.isRollback,
      replyMessage: replyMessage ?? this.replyMessage,
      likes: likes ?? this.likes,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      isCall: isCall ?? this.isCall,
      missedCall: missedCall ?? this.missedCall,
      isRejectCallId: isRejectCallId ?? this.isRejectCallId,
      isCanceldId: isCanceldId ?? this.isCanceldId,
      callStartedAt: callStartedAt ?? this.callStartedAt,
      callJoinedAt: callJoinedAt ?? this.callJoinedAt,
      callEndAt: callEndAt ?? this.callEndAt,
    );
  }
}
