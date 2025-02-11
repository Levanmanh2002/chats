import 'package:json_annotation/json_annotation.dart';

part 'sender_request_friend.g.dart';

@JsonSerializable()
class SenderRequestFriend {
  int? id;

  @JsonKey(name: 'sender_id')
  int? senderId;

  @JsonKey(name: 'receiver_id')
  int? receiverId;

  String? status;

  @JsonKey(name: 'created_at')
  String? createdAt;

  @JsonKey(name: 'updated_at')
  String? updatedAt;

  SenderRequestFriend({
    this.id,
    this.senderId,
    this.receiverId,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory SenderRequestFriend.fromJson(Map<String, dynamic> json) => _$SenderRequestFriendFromJson(json);
  Map<String, dynamic> toJson() => _$SenderRequestFriendToJson(this);
}
