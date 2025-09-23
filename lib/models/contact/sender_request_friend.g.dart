// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sender_request_friend.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SenderRequestFriend _$SenderRequestFriendFromJson(Map<String, dynamic> json) =>
    SenderRequestFriend(
      id: (json['id'] as num?)?.toInt(),
      senderId: (json['sender_id'] as num?)?.toInt(),
      receiverId: (json['receiver_id'] as num?)?.toInt(),
      status: json['status'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$SenderRequestFriendToJson(
        SenderRequestFriend instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sender_id': instance.senderId,
      'receiver_id': instance.receiverId,
      'status': instance.status,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
