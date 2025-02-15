import 'package:json_annotation/json_annotation.dart';

part 'quick_message.g.dart';

@JsonSerializable()
class QuickMessage {
  int? id;

  @JsonKey(name: 'short_key')
  String? shortKey;

  String? content;

  @JsonKey(name: 'created_at')
  String? createdAt;

  QuickMessage({
    this.id,
    this.shortKey,
    this.content,
    this.createdAt,
  });

  factory QuickMessage.fromJson(Map<String, dynamic> json) => _$QuickMessageFromJson(json);

  Map<String, dynamic> toJson() => _$QuickMessageToJson(this);

  static List<QuickMessage> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => QuickMessage.fromJson(json)).toList();
  }
}
