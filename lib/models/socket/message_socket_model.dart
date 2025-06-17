import 'package:chats/models/messages/message_data_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message_socket_model.g.dart';

@JsonSerializable()
class MessageSocketModel {
  String? title;
  MessageDataModel? data;
  String? type;

  MessageSocketModel({
    this.title,
    this.data,
    this.type,
  });

  factory MessageSocketModel.fromJson(Map<String, dynamic> json) => _$MessageSocketModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageSocketModelToJson(this);
}
