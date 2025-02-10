import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  int? id;
  String? name;
  String? avatar;
  String? phone;
  String? birthday;
  String? gender;
  String? address;

  @JsonKey(name: 'is_enavle_security')
  bool? isEnableSecurity;

  UserModel({
    this.id,
    this.name,
    this.avatar,
    this.phone,
    this.birthday,
    this.gender,
    this.address,
    this.isEnableSecurity,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
