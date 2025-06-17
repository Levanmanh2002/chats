import 'package:chats/models/chats/chat_data_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_socket_model.g.dart';

@JsonSerializable()
class ChatSocketModel {
  String? title;
  ChatDataModel? data;
  String? type;

  ChatSocketModel({
    this.title,
    this.data,
    this.type,
  });

  factory ChatSocketModel.fromJson(Map<String, dynamic> json) => _$ChatSocketModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatSocketModelToJson(this);
}
