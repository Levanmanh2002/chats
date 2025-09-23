import 'package:chats/resourese/home/ihome_repository.dart';
import 'package:chats/utils/app_constants.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class HomeRepository extends IHomeRepository {
  @override
  Future<Response> getDashboardOverview() async {
    try {
      final result = await clientGetData(AppConstants.dashboardOverviewUri);
      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> getWorkStatusChart() async {
    try {
      final result = await clientGetData(AppConstants.workStatusChartUri);
      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> getCalendarData({required int month, required int year}) async {
    try {
      final result = await clientGetData(AppConstants.calendarDataUri(month, year));
      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }
}
