import 'package:chats/resourese/dashboard/idashboard_repository.dart';
import 'package:chats/utils/app_constants.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class DashboardRepository extends IDashboardRepository {
  @override
  Future<Response> updateFcmToken() async {
    try {
      final result = await clientPostData(AppConstants.updateFcmTokenUri, {
        'fcm_token': '',
      });

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }
}
