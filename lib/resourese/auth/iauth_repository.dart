import 'package:chats/models/request/sign_up_request.dart';
import 'package:chats/resourese/ibase_repository.dart';
import 'package:get/get_connect/http/src/response/response.dart';

abstract class IAuthRepository extends IBaseRepository {
  Future<Response> signIn(Map<String, String> params);
  Future<Response> signUp(SignUpRequest signUpRequest);
  Future<Response> forgotPassword(Map<String, String> params);
  Future<Response> updatePassword(Map<String, String> params);
  Future<Response> requestOtp(String phone);
  Future<Response> verifyOtp(Map<String, String> params);
}
