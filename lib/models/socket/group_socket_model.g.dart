// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_socket_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupSocketModel _$GroupSocketModelFromJson(Map<String, dynamic> json) =>
    GroupSocketModel(
      title: json['title'] as String?,
      data: json['data'] == null
          ? null
          : GroupSocketData.fromJson(json['data'] as Map<String, dynamic>),
      type: json['type'] as String?,
    );

Map<String, dynamic> _$GroupSocketModelToJson(GroupSocketModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'data': instance.data,
      'type': instance.type,
    };

GroupSocketData _$GroupSocketDataFromJson(Map<String, dynamic> json) =>
    GroupSocketData(
      chat: json['chat'] == null
          ? null
          : ChatDataModel.fromJson(json['chat'] as Map<String, dynamic>),
      users: (json['users'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      message: json['message'] == null
          ? null
          : MessageGroup.fromJson(json['message'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GroupSocketDataToJson(GroupSocketData instance) =>
    <String, dynamic>{
      'chat': instance.chat,
      'users': instance.users,
      'message': instance.message,
    };

MessageGroup _$MessageGroupFromJson(Map<String, dynamic> json) => MessageGroup(
      id: (json['id'] as num?)?.toInt(),
      chatId: (json['chat_id'] as num?)?.toInt(),
      senderId: (json['sender_id'] as num?)?.toInt(),
      message: json['message'] as String?,
      replyMessageId: (json['reply_message_id'] as num?)?.toInt(),
      hasUserRemovedFromGroup:
          (json['has_user_removed_from_group'] as num?)?.toInt(),
      hasUserAddedToGroup: (json['has_user_added_to_group'] as num?)?.toInt(),
      updatedAt: json['updated_at'] as String?,
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$MessageGroupToJson(MessageGroup instance) =>
    <String, dynamic>{
      'id': instance.id,
      'chat_id': instance.chatId,
      'sender_id': instance.senderId,
      'message': instance.message,
      'reply_message_id': instance.replyMessageId,
      'has_user_removed_from_group': instance.hasUserRemovedFromGroup,
      'has_user_added_to_group': instance.hasUserAddedToGroup,
      'updated_at': instance.updatedAt,
      'created_at': instance.createdAt,
    };
