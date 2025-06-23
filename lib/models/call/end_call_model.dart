import 'package:chats/utils/json_utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'end_call_model.g.dart';

@JsonSerializable()
class EndCallModel {
  @JsonKey(name: 'pusher_id', fromJson: parseToInt)
  int? pusherId;

  String? title;
  String? type;

  @JsonKey(name: 'is_call', fromJson: parseToInt)
  int? isCall;

  @JsonKey(name: 'call_token')
  String? callToken;

  @JsonKey(name: 'channel_name')
  String? channelName;

  @JsonKey(name: 'call_action')
  String? callAction;

  EndCallModel({
    this.pusherId,
    this.title,
    this.type,
    this.isCall,
    this.callToken,
    this.channelName,
    this.callAction,
  });

  factory EndCallModel.fromJson(Map<String, dynamic> json) => _$EndCallModelFromJson(json);

  Map<String, dynamic> toJson() => _$EndCallModelToJson(this);
}
