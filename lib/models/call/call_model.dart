import 'package:chats/utils/json_utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'call_model.g.dart';

@JsonSerializable()
class ChatModel {
  String? title;
  CallData? data;
  String? type;

  ChatModel({
    this.title,
    this.data,
    this.type,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) => _$ChatModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatModelToJson(this);
}

@JsonSerializable()
class CallData {
  String? type;

  @JsonKey(name: 'is_call', fromJson: parseToInt)
  int? isCall;

  int? id;

  @JsonKey(name: 'call_id', fromJson: parseToInt)
  int? callId;

  @JsonKey(name: 'call_token')
  String? callToken;

  @JsonKey(name: 'channel_name')
  String? channelName;

  @JsonKey(name: 'user_id', fromJson: parseToInt)
  int? userId;

  @JsonKey(name: 'user_name')
  String? userName;

  @JsonKey(name: 'user_avatar')
  String? userAvatar;

  @JsonKey(name: 'user_phone')
  String? userPhone;

  @JsonKey(name: 'call_action')
  String? callAction;

  CallData({
    this.type,
    this.isCall,
    this.id,
    this.callId,
    this.callToken,
    this.channelName,
    this.userId,
    this.userName,
    this.userAvatar,
    this.userPhone,
    this.callAction,
  });

  factory CallData.fromJson(Map<String, dynamic> json) => _$CallDataFromJson(json);
  Map<String, dynamic> toJson() => _$CallDataToJson(this);
}
