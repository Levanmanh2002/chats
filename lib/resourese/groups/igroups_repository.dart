import 'package:chats/resourese/ibase_repository.dart';
import 'package:get/get_connect/http/src/response/response.dart';

abstract class IGroupsRepository extends IBaseRepository {
  Future<Response> createGroup(Map<String, dynamic> params);
  Future<Response> sendMessageGroup(Map<String, String> body, List<MultipartBody> multipartBody);
  Future<Response> renameGroup(int id, String name);
  Future<Response> addUserToGroup(Map<String, dynamic> params);
  Future<Response> removeUserFromGroup(Map<String, dynamic> params);
  Future<Response> transferOwnership(Map<String, dynamic> params);
}
