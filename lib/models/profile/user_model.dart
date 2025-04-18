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

  @JsonKey(name: 'security_code')
  String? securityCode;

  @JsonKey(name: 'is_friend')
  bool? isFriend;

  @JsonKey(name: 'is_sender_request_friend')
  bool? isSenderRequestFriend;

  @JsonKey(name: 'is_receiver_id_request_friend')
  bool? isReceiverIdRequestFriend;

  @JsonKey(name: 'last_online')
  String? lastOnline;

  @JsonKey(name: 'auto_message')
  String? autoMessage;

  @JsonKey(name: 'security_code_screen')
  String? securityCodeScreen;

  @JsonKey(name: 'is_enavle_security_screen')
  bool? isEnableSecurityScreen;

  @JsonKey(name: 'is_checked')
  bool? isChecked;

  UserModel({
    this.id,
    this.name,
    this.avatar,
    this.phone,
    this.birthday,
    this.gender,
    this.address,
    this.isEnableSecurity,
    this.securityCode,
    this.isFriend,
    this.isSenderRequestFriend,
    this.isReceiverIdRequestFriend,
    this.lastOnline,
    this.autoMessage,
    this.securityCodeScreen,
    this.isEnableSecurityScreen,
    this.isChecked,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  static List<UserModel> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => UserModel.fromJson(json)).toList();
  }
}
