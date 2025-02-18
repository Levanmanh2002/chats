import 'package:chats/resourese/ibase_repository.dart';
import 'package:get/get_connect/http/src/response/response.dart';

abstract class IDashboardRepository extends IBaseRepository {
  Future<Response> updateFcmToken();
  Future<Response> systemSettings();
}
