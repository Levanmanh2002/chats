// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reply_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReplyMessage _$ReplyMessageFromJson(Map<String, dynamic> json) => ReplyMessage(
      id: (json['id'] as num?)?.toInt(),
      message: json['message'] as String?,
      sender: json['sender'] == null
          ? null
          : UserModel.fromJson(json['sender'] as Map<String, dynamic>),
      chatId: (json['chat_id'] as num?)?.toInt(),
      files: (json['files'] as List<dynamic>?)
          ?.map((e) => FilesModels.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$ReplyMessageToJson(ReplyMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'message': instance.message,
      'sender': instance.sender,
      'chat_id': instance.chatId,
      'files': instance.files,
      'created_at': instance.createdAt,
    };
