// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_setting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SystemSetting _$SystemSettingFromJson(Map<String, dynamic> json) =>
    SystemSetting(
      pusher: json['pusher'] == null
          ? null
          : Pusher.fromJson(json['pusher'] as Map<String, dynamic>),
      page: json['page'] == null
          ? null
          : PageData.fromJson(json['page'] as Map<String, dynamic>),
      iosVersion: json['ios_version'] as String?,
      iosUlr: json['ios_ulr'] as String?,
      androidVersion: json['android_version'] as String?,
      androidUrl: json['android_url'] as String?,
      documentUrl: json['document_url'] as String?,
      hideChat: json['hide_chat'] as bool? ?? false,
      bot: json['bot'] == null
          ? null
          : BotModel.fromJson(json['bot'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SystemSettingToJson(SystemSetting instance) =>
    <String, dynamic>{
      'pusher': instance.pusher,
      'page': instance.page,
      'ios_version': instance.iosVersion,
      'ios_ulr': instance.iosUlr,
      'android_version': instance.androidVersion,
      'android_url': instance.androidUrl,
      'document_url': instance.documentUrl,
      'hide_chat': instance.hideChat,
      'bot': instance.bot,
    };

Pusher _$PusherFromJson(Map<String, dynamic> json) => Pusher(
      appId: json['app_id'] as String?,
      key: json['key'] as String?,
      secret: json['secret'] as String?,
      cluster: json['cluster'] as String?,
    );

Map<String, dynamic> _$PusherToJson(Pusher instance) => <String, dynamic>{
      'app_id': instance.appId,
      'key': instance.key,
      'secret': instance.secret,
      'cluster': instance.cluster,
    };

PageData _$PageDataFromJson(Map<String, dynamic> json) => PageData(
      policy: json['policy'] as String?,
      contactPhone: json['contact_phone'] as String?,
    );

Map<String, dynamic> _$PageDataToJson(PageData instance) => <String, dynamic>{
      'policy': instance.policy,
      'contact_phone': instance.contactPhone,
    };

BotModel _$BotModelFromJson(Map<String, dynamic> json) => BotModel(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      avatar: json['avatar'] as String?,
    );

Map<String, dynamic> _$BotModelToJson(BotModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'avatar': instance.avatar,
    };
