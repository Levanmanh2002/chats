// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      avatar: json['avatar'] as String?,
      phone: json['phone'] as String?,
      birthday: json['birthday'] as String?,
      gender: json['gender'] as String?,
      address: json['address'] as String?,
      isEnableSecurity: json['is_enavle_security'] as bool?,
      securityCode: json['security_code'] as String?,
      isFriend: json['is_friend'] as bool?,
      isSenderRequestFriend: json['is_sender_request_friend'] as bool?,
      isReceiverIdRequestFriend: json['is_receiver_id_request_friend'] as bool?,
      lastOnline: json['last_online'] as String?,
      autoMessage: json['auto_message'] as String?,
      securityCodeScreen: json['security_code_screen'] as String?,
      isEnableSecurityScreen: json['is_enavle_security_screen'] as bool?,
      isChecked: json['is_checked'] as bool?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'avatar': instance.avatar,
      'phone': instance.phone,
      'birthday': instance.birthday,
      'gender': instance.gender,
      'address': instance.address,
      'is_enavle_security': instance.isEnableSecurity,
      'security_code': instance.securityCode,
      'is_friend': instance.isFriend,
      'is_sender_request_friend': instance.isSenderRequestFriend,
      'is_receiver_id_request_friend': instance.isReceiverIdRequestFriend,
      'last_online': instance.lastOnline,
      'auto_message': instance.autoMessage,
      'security_code_screen': instance.securityCodeScreen,
      'is_enavle_security_screen': instance.isEnableSecurityScreen,
      'is_checked': instance.isChecked,
    };
