import 'package:chats/utils/json_utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'channel_call_event.g.dart';

@JsonSerializable()
class CallModel {
  @JsonKey(name: 'channel_name')
  String? channelName;

  @JsonKey(name: 'is_call', fromJson: parseToInt)
  int? isCall;

  @JsonKey(fromJson: parseToInt)
  int? id;

  String? type;

  String? name;
  String? avatar;
  String? phone;

  @JsonKey(name: 'call_id', fromJson: parseToInt)
  int? callId;

  @JsonKey(name: 'call_token')
  String? callToken;

  CallModel({
    this.channelName,
    this.isCall,
    this.id,
    this.type,
    this.name,
    this.avatar,
    this.phone,
    this.callId,
    this.callToken,
  });

  factory CallModel.fromJson(Map<String, dynamic> json) => _$CallModelFromJson(json);

  Map<String, dynamic> toJson() => _$CallModelToJson(this);
}

@JsonSerializable()
class UserModel {
  @JsonKey(fromJson: parseToInt)
  int? id;

  String? name;
  String? avatar;
  String? phone;

  UserModel({
    this.id,
    this.name,
    this.avatar,
    this.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
