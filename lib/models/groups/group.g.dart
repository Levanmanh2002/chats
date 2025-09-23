// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupModel _$GroupModelFromJson(Map<String, dynamic> json) => GroupModel(
      id: (json['id'] as num?)?.toInt(),
      groupName: json['group_name'] as String?,
      groupUsers: (json['group_users'] as List<dynamic>?)
          ?.map((e) => UserModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      latestMessage: json['latest_message'] == null
          ? null
          : MessageDataModel.fromJson(
              json['latest_message'] as Map<String, dynamic>),
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$GroupModelToJson(GroupModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'group_name': instance.groupName,
      'group_users': instance.groupUsers,
      'latest_message': instance.latestMessage,
      'created_at': instance.createdAt,
    };
