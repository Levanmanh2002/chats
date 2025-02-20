import 'dart:developer';

import 'package:chats/resourese/dashboard/idashboard_repository.dart';
import 'package:chats/utils/app_constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class DashboardRepository extends IDashboardRepository {
  @override
  Future<Response> updateFcmToken() async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();

      log('fcmToken: $fcmToken', name: 'FCM Token');

      final result = await clientPostData(AppConstants.updateFcmTokenUri, {
        'fcm_token': fcmToken,
      });

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> systemSettings() async {
    try {
      final result = await clientGetData(AppConstants.systemSettingsUri);

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> trackingTimeOnline() async {
    try {
      final result = await clientPostData(AppConstants.trackingTimeOnlineUri, {});

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }
}
