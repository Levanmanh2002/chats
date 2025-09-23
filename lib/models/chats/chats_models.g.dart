// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chats_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatsModels _$ChatsModelsFromJson(Map<String, dynamic> json) => ChatsModels(
      chat: (json['data'] as List<dynamic>?)
          ?.map((e) => ChatDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPage: parseToInt(json['totalPage']),
      totalCount: parseToInt(json['totalCount']),
      page: parseToInt(json['page']),
      size: parseToInt(json['size']),
    );

Map<String, dynamic> _$ChatsModelsToJson(ChatsModels instance) =>
    <String, dynamic>{
      'data': instance.chat,
      'totalPage': instance.totalPage,
      'totalCount': instance.totalCount,
      'page': instance.page,
      'size': instance.size,
    };
