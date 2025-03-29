import 'package:chats/resourese/ibase_repository.dart';
import 'package:get/get_connect/http/src/response/response.dart';

abstract class IProfileRepository extends IBaseRepository {
  Future<Response> profile();
  Future<Response> logout();
  Future<Response> updateAvatar(List<MultipartBody> multipartBody);
  Future<Response> updateProfile(Map<String, dynamic> params);
  Future<Response> updateNewPassword(Map<String, dynamic> params);
  Future<Response> deleteAccount();
  Future<Response> endableSecurity(String securityPass);
  Future<Response> disableSecurity(String securityPass);
  Future<Response> changeSecurity(String securityPass);
  Future<Response> syncContacts(Map<String, dynamic> params);

  Future<Response> screenEndableSecurity(String securityPass);
  Future<Response> screenDisableSecurity(String securityPass);
  Future<Response> screenChangeSecurity(String securityPass);
}
