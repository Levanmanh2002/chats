// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_socket_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatSocketModel _$ChatSocketModelFromJson(Map<String, dynamic> json) =>
    ChatSocketModel(
      title: json['title'] as String?,
      data: json['data'] == null
          ? null
          : ChatDataModel.fromJson(json['data'] as Map<String, dynamic>),
      type: json['type'] as String?,
    );

Map<String, dynamic> _$ChatSocketModelToJson(ChatSocketModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'data': instance.data,
      'type': instance.type,
    };
