import 'package:chats/models/chats/chat_data_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pusher_chat.g.dart';

@JsonSerializable()
class PusherChatModel {
  @JsonKey(name: 'user_id')
  int? userId;

  PayloadChat? payload;

  PusherChatModel({
    this.userId,
    this.payload,
  });

  factory PusherChatModel.fromJson(Map<String, dynamic> json) => _$PusherChatModelFromJson(json);

  Map<String, dynamic> toJson() => _$PusherChatModelToJson(this);
}

@JsonSerializable()
class PayloadChat {
  String? title;
  ChatDataModel? data;
  String? type;

  PayloadChat({
    this.title,
    this.data,
    this.type,
  });

  factory PayloadChat.fromJson(Map<String, dynamic> json) => _$PayloadChatFromJson(json);

  Map<String, dynamic> toJson() => _$PayloadChatToJson(this);
}
