import 'package:chats/models/profile/user_model.dart';
import 'package:chats/utils/json_utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'contact_model.g.dart';

extension ContactModelDataExtension on ContactModelData {
  bool get hasNext => ((data?.length ?? 0)) < (totalPage ?? 0);
}

@JsonSerializable()
class ContactModelData {
  List<ContactModel>? data;

  @JsonKey(fromJson: parseToInt)
  int? totalPage;

  @JsonKey(fromJson: parseToInt)
  int? totalCount;

  @JsonKey(fromJson: parseToInt)
  int? page;

  @JsonKey(fromJson: parseToInt)
  int? size;

  ContactModelData({
    this.data,
    this.totalPage,
    this.totalCount,
    this.page,
    this.size,
  });

  factory ContactModelData.fromJson(Map<String, dynamic> json) => _$ContactModelDataFromJson(json);
  Map<String, dynamic> toJson() => _$ContactModelDataToJson(this);
}

@JsonSerializable()
class ContactModel {
  int? id;
  String? status;
  UserModel? friend;

  @JsonKey(name: 'created_at')
  String? createdAt;

  ContactModel({
    this.id,
    this.status,
    this.friend,
    this.createdAt,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) => _$ContactModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContactModelToJson(this);
}
