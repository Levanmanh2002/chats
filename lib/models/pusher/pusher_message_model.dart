import 'package:chats/models/messages/message_data_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pusher_message_model.g.dart';

@JsonSerializable()
class PusherMesageModel {
  @JsonKey(name: 'user_id')
  int? userId;

  Payload? payload;

  PusherMesageModel({
    this.userId,
    this.payload,
  });

  factory PusherMesageModel.fromJson(Map<String, dynamic> json) => _$PusherMesageModelFromJson(json);

  Map<String, dynamic> toJson() => _$PusherMesageModelToJson(this);
}

@JsonSerializable()
class Payload {
  String? title;
  MessageDataModel? data;
  String? type;

  Payload({
    this.title,
    this.data,
    this.type,
  });

  factory Payload.fromJson(Map<String, dynamic> json) => _$PayloadFromJson(json);

  Map<String, dynamic> toJson() => _$PayloadToJson(this);
}
