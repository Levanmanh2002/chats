// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quick_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuickMessage _$QuickMessageFromJson(Map<String, dynamic> json) => QuickMessage(
      id: (json['id'] as num?)?.toInt(),
      shortKey: json['short_key'] as String?,
      content: json['content'] as String?,
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$QuickMessageToJson(QuickMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'short_key': instance.shortKey,
      'content': instance.content,
      'created_at': instance.createdAt,
    };
