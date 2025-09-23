// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageModels _$MessageModelsFromJson(Map<String, dynamic> json) =>
    MessageModels(
      chat: json['chat'] == null
          ? null
          : ChatDataModel.fromJson(json['chat'] as Map<String, dynamic>),
      listMessages: (json['listMessages'] as List<dynamic>?)
          ?.map((e) => MessageDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPage: parseToInt(json['totalPage']),
      totalCount: parseToInt(json['totalCount']),
      page: parseToInt(json['page']),
      size: parseToInt(json['size']),
      highlightedMessages: (json['highlightedMessages'] as List<dynamic>?)
          ?.map((e) => MessageDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      highlightedPages: (json['highlightedPages'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      isFriend: parseToBool(json['is_friend']),
      isSenderRequestFriend: parseToBool(json['is_sender_request_friend']),
      isReceiverIdRequestFriend:
          parseToBool(json['is_receiver_id_request_friend']),
      requestFriend: json['request_friend'] == null
          ? null
          : SenderRequestFriend.fromJson(
              json['request_friend'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MessageModelsToJson(MessageModels instance) =>
    <String, dynamic>{
      'chat': instance.chat,
      'listMessages': instance.listMessages,
      'totalPage': instance.totalPage,
      'totalCount': instance.totalCount,
      'page': instance.page,
      'size': instance.size,
      'highlightedMessages': instance.highlightedMessages,
      'highlightedPages': instance.highlightedPages,
      'is_friend': instance.isFriend,
      'is_sender_request_friend': instance.isSenderRequestFriend,
      'is_receiver_id_request_friend': instance.isReceiverIdRequestFriend,
      'request_friend': instance.requestFriend,
    };
