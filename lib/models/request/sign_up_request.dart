import 'package:json_annotation/json_annotation.dart';

part 'sign_up_request.g.dart';

@JsonSerializable()
class SignUpRequest {
  String name;
  String phone;
  String password;

  @JsonKey(name: 'confirm_password')
  String confirmPassword;

  String birthday;
  String gender;
  String address;

  @JsonKey(name: 'otp_token')
  String? otpToken;

  SignUpRequest({
    required this.name,
    required this.phone,
    required this.password,
    required this.confirmPassword,
    required this.birthday,
    required this.gender,
    required this.address,
    this.otpToken,
  });

  factory SignUpRequest.fromJson(Map<String, dynamic> json) => _$SignUpRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpRequestToJson(this);

  SignUpRequest copyWith({
    String? name,
    String? phone,
    String? password,
    String? confirmPassword,
    String? birthday,
    String? gender,
    String? address,
    String? otpToken,
  }) {
    return SignUpRequest(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      birthday: birthday ?? this.birthday,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      otpToken: otpToken ?? this.otpToken,
    );
  }
}
