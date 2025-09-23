// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageDataModel _$MessageDataModelFromJson(Map<String, dynamic> json) =>
    MessageDataModel(
      id: (json['id'] as num?)?.toInt(),
      message: json['message'] as String?,
      sender: json['sender'] == null
          ? null
          : UserModel.fromJson(json['sender'] as Map<String, dynamic>),
      chatId: (json['chat_id'] as num?)?.toInt(),
      files: (json['files'] as List<dynamic>?)
          ?.map((e) => FilesModels.fromJson(e as Map<String, dynamic>))
          .toList(),
      sticker: json['sticker'] == null
          ? null
          : TickersModel.fromJson(json['sticker'] as Map<String, dynamic>),
      isRollback: json['is_rollback'] as bool?,
      hasUserAddedToGroup: json['has_user_added_to_group'] as bool?,
      hasUserRemovedFromGroup: json['has_user_removed_from_group'] as bool?,
      hasUserLeftGroup: json['has_user_left_group'] as bool?,
      replyMessage: json['reply_message'] == null
          ? null
          : ReplyMessage.fromJson(
              json['reply_message'] as Map<String, dynamic>),
      likes: (json['likes'] as List<dynamic>?)
          ?.map((e) => LikeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['created_at'] as String?,
      isCall: parseToBool(json['is_call']),
      missedCall: json['missed_call'] as bool?,
      isDontPickUp: json['is_dont_pick_up'] as bool?,
      isRejectCallId: parseToInt(json['is_reject_call_id']),
      isCanceldId: parseToInt(json['is_canceld_id']),
      callStartedAt: json['call_started_at'] as String?,
      callJoinedAt: json['call_joined_at'] as String?,
      callEndAt: json['call_end_at'] as String?,
    );

Map<String, dynamic> _$MessageDataModelToJson(MessageDataModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'message': instance.message,
      'sender': instance.sender,
      'chat_id': instance.chatId,
      'files': instance.files,
      'is_rollback': instance.isRollback,
      'has_user_added_to_group': instance.hasUserAddedToGroup,
      'has_user_removed_from_group': instance.hasUserRemovedFromGroup,
      'has_user_left_group': instance.hasUserLeftGroup,
      'reply_message': instance.replyMessage,
      'likes': instance.likes,
      'sticker': instance.sticker,
      'created_at': instance.createdAt,
      'is_call': instance.isCall,
      'missed_call': instance.missedCall,
      'is_dont_pick_up': instance.isDontPickUp,
      'is_reject_call_id': instance.isRejectCallId,
      'is_canceld_id': instance.isCanceldId,
      'call_started_at': instance.callStartedAt,
      'call_joined_at': instance.callJoinedAt,
      'call_end_at': instance.callEndAt,
    };
