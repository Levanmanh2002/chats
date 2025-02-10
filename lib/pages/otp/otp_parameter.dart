import 'package:chats/models/request/sign_up_request.dart';

enum OtpType { signIn, signUp, forgotPassword }

class OtpParameter {
  final OtpType type;
  final String? contact;
  final SignUpRequest? signUpRequest;

  OtpParameter({required this.type, this.contact, this.signUpRequest});
}
