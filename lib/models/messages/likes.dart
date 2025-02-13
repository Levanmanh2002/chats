import 'package:chats/models/profile/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'likes.g.dart';

@JsonSerializable()
class LikeModel {
  int? id;
  UserModel? user;

  @JsonKey(name: 'created_at')
  String? createdAt;

  LikeModel({
    this.id,
    this.user,
    this.createdAt,
  });

  factory LikeModel.fromJson(Map<String, dynamic> json) => _$LikeModelFromJson(json);
  Map<String, dynamic> toJson() => _$LikeModelToJson(this);
}
