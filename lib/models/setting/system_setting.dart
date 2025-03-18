import 'package:json_annotation/json_annotation.dart';

part 'system_setting.g.dart';

@JsonSerializable()
class SystemSetting {
  Pusher? pusher;

  @JsonKey(name: 'page')
  PageData? page;

  @JsonKey(name: 'ios_version')
  String? iosVersion;

  @JsonKey(name: 'ios_ulr')
  String? iosUlr;

  @JsonKey(name: 'android_version')
  String? androidVersion;

  @JsonKey(name: 'android_url')
  String? androidUrl;

  @JsonKey(name: 'document_url')
  String? documentUrl;

  SystemSetting({
    this.pusher,
    this.page,
    this.iosVersion,
    this.iosUlr,
    this.androidVersion,
    this.androidUrl,
    this.documentUrl,
  });

  factory SystemSetting.fromJson(Map<String, dynamic> json) => _$SystemSettingFromJson(json);
  Map<String, dynamic> toJson() => _$SystemSettingToJson(this);
}

@JsonSerializable()
class Pusher {
  @JsonKey(name: 'app_id')
  String? appId;

  String? key;
  String? secret;
  String? cluster;

  Pusher({
    this.appId,
    this.key,
    this.secret,
    this.cluster,
  });

  factory Pusher.fromJson(Map<String, dynamic> json) => _$PusherFromJson(json);
  Map<String, dynamic> toJson() => _$PusherToJson(this);
}

@JsonSerializable()
class PageData {
  String? policy;

  @JsonKey(name: 'contact_phone')
  String? contactPhone;

  PageData({
    this.policy,
    this.contactPhone,
  });

  factory PageData.fromJson(Map<String, dynamic> json) => _$PageDataFromJson(json);
  Map<String, dynamic> toJson() => _$PageDataToJson(this);
}
