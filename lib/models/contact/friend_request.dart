import 'package:chats/models/profile/user_model.dart';
import 'package:chats/utils/json_utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'friend_request.g.dart';

extension FriendRequestDataExtension on FriendRequestData {
  bool get hasNext => ((data?.length ?? 0)) < (totalPage ?? 0);
}

@JsonSerializable()
class FriendRequestData {
  List<FriendRequest>? data;

  @JsonKey(fromJson: parseToInt)
  int? totalPage;

  @JsonKey(fromJson: parseToInt)
  int? totalCount;

  @JsonKey(fromJson: parseToInt)
  int? page;

  @JsonKey(fromJson: parseToInt)
  int? size;

  FriendRequestData({
    this.data,
    this.totalPage,
    this.totalCount,
    this.page,
    this.size,
  });

  factory FriendRequestData.fromJson(Map<String, dynamic> json) => _$FriendRequestDataFromJson(json);
  Map<String, dynamic> toJson() => _$FriendRequestDataToJson(this);
}

@JsonSerializable()
class FriendRequest {
  int? id;
  String? status;
  UserModel? receiver;

  @JsonKey(name: 'created_at')
  String? createdAt;

  FriendRequest({
    this.id,
    this.status,
    this.receiver,
    this.createdAt,
  });

  factory FriendRequest.fromJson(Map<String, dynamic> json) => _$FriendRequestFromJson(json);
  Map<String, dynamic> toJson() => _$FriendRequestToJson(this);
}
