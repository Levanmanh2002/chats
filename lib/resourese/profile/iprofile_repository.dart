import 'package:chats/resourese/ibase_repository.dart';
import 'package:get/get_connect/http/src/response/response.dart';

abstract class IProfileRepository extends IBaseRepository {
  Future<Response> profile();
  Future<Response> logout();
  Future<Response> updateAvatar(List<MultipartBody> multipartBody);
}
