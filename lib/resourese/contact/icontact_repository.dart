import 'package:chats/resourese/ibase_repository.dart';
import 'package:get/get_connect/http/src/response/response.dart';

abstract class IContactRepository extends IBaseRepository {
  Future<Response> searchContactPhone(String phone);
  Future<Response> findAccount(String phone);
}
