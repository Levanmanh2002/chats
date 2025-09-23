// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_socket_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageSocketModel _$MessageSocketModelFromJson(Map<String, dynamic> json) =>
    MessageSocketModel(
      title: json['title'] as String?,
      data: json['data'] == null
          ? null
          : MessageDataModel.fromJson(json['data'] as Map<String, dynamic>),
      type: json['type'] as String?,
    );

Map<String, dynamic> _$MessageSocketModelToJson(MessageSocketModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'data': instance.data,
      'type': instance.type,
    };
