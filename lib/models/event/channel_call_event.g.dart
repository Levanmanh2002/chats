// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_call_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallModel _$CallModelFromJson(Map<String, dynamic> json) => CallModel(
      channelName: json['channel_name'] as String?,
      isCall: parseToInt(json['is_call']),
      id: parseToInt(json['id']),
      type: json['type'] as String?,
      name: json['name'] as String?,
      avatar: json['avatar'] as String?,
      phone: json['phone'] as String?,
      callId: parseToInt(json['call_id']),
      callToken: json['call_token'] as String?,
    );

Map<String, dynamic> _$CallModelToJson(CallModel instance) => <String, dynamic>{
      'channel_name': instance.channelName,
      'is_call': instance.isCall,
      'id': instance.id,
      'type': instance.type,
      'name': instance.name,
      'avatar': instance.avatar,
      'phone': instance.phone,
      'call_id': instance.callId,
      'call_token': instance.callToken,
    };

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: parseToInt(json['id']),
      name: json['name'] as String?,
      avatar: json['avatar'] as String?,
      phone: json['phone'] as String?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'avatar': instance.avatar,
      'phone': instance.phone,
    };
