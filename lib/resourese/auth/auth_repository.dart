import 'package:chats/models/request/sign_up_request.dart';
import 'package:chats/resourese/auth/iauth_repository.dart';
import 'package:chats/utils/app_constants.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class AuthRepository extends IAuthRepository {
  @override
  Future<Response> signIn(Map<String, String> params) async {
    try {
      final result = await clientPostData(AppConstants.signInUri, params);

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> signUp(SignUpRequest signUpRequest) async {
    try {
      final result = await clientPostData(AppConstants.signUpUri, signUpRequest.toJson());

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> forgotPassword(Map<String, String> params) async {
    try {
      final result = await clientPostData(AppConstants.forgotPasswordUri, params);

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> updatePassword(Map<String, String> params) async {
    try {
      final result = await clientPostData(AppConstants.updatePasswordUri, params);

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> requestOtp(String phone) async {
    try {
      final result = await clientPostData(AppConstants.requestOtpUri, {
        'phone': phone,
      });

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> verifyOtp(Map<String, String> params) async {
    try {
      final result = await clientPostData(AppConstants.verifyOtpUri, params);

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }
}
