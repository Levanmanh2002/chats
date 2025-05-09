import 'dart:developer';
import 'dart:io';

import 'package:chats/resourese/dashboard/idashboard_repository.dart';
import 'package:chats/utils/app_constants.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class DashboardRepository extends IDashboardRepository {
  @override
  Future<Response> updateFcmToken() async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();

      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      String? deviceId;

      if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor;
      } else if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.id;
      } else {
        WebBrowserInfo webInfo = await deviceInfo.webBrowserInfo;
        deviceId = "${webInfo.vendor}-${webInfo.userAgent}-${webInfo.hardwareConcurrency}";
      }

      final result = await clientPostData(AppConstants.updateFcmTokenUri, {
        'fcm_token': fcmToken.toString(),
        'device_id': deviceId.toString(),
      });

      log('deviceId: $deviceId');

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

  @override
  Future<Response> getTickers() async {
    try {
      final result = await clientGetData(AppConstants.getTickersUri);

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }
}
