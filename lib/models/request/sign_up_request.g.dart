// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignUpRequest _$SignUpRequestFromJson(Map<String, dynamic> json) =>
    SignUpRequest(
      name: json['name'] as String,
      phone: json['phone'] as String,
      password: json['password'] as String,
      confirmPassword: json['confirm_password'] as String,
      birthday: json['birthday'] as String,
      gender: json['gender'] as String,
      address: json['address'] as String,
      otpToken: json['otp_token'] as String?,
    );

Map<String, dynamic> _$SignUpRequestToJson(SignUpRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'phone': instance.phone,
      'password': instance.password,
      'confirm_password': instance.confirmPassword,
      'birthday': instance.birthday,
      'gender': instance.gender,
      'address': instance.address,
      'otp_token': instance.otpToken,
    };
