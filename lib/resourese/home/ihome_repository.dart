import 'package:chats/resourese/ibase_repository.dart';
import 'package:get/get_connect/http/src/response/response.dart';

abstract class IHomeRepository extends IBaseRepository {
  Future<Response> getDashboardOverview();
  Future<Response> getWorkStatusChart();
  Future<Response> getCalendarData({required int month, required int year});
}
