// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatDataModel _$ChatDataModelFromJson(Map<String, dynamic> json) =>
    ChatDataModel(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      owner: json['owner'] == null
          ? null
          : UserModel.fromJson(json['owner'] as Map<String, dynamic>),
      isGroup: parseFromBoolToInt(json['is_group']),
      isRead: json['is_read'] as bool?,
      users: (json['users'] as List<dynamic>?)
          ?.map((e) => UserModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      latestMessage: json['latest_message'] == null
          ? null
          : MessageDataModel.fromJson(
              json['latest_message'] as Map<String, dynamic>),
      isHide: parseToBool(json['is_hide']),
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$ChatDataModelToJson(ChatDataModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'owner': instance.owner,
      'is_group': instance.isGroup,
      'is_read': instance.isRead,
      'users': instance.users,
      'latest_message': instance.latestMessage,
      'is_hide': instance.isHide,
      'created_at': instance.createdAt,
    };
