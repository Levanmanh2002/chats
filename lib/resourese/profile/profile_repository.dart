import 'dart:io';

import 'package:chats/resourese/ibase_repository.dart';
import 'package:chats/resourese/profile/iprofile_repository.dart';
import 'package:chats/utils/app_constants.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class ProfileRepository extends IProfileRepository {
  @override
  Future<Response> profile() async {
    try {
      final result = await clientGetData(AppConstants.profileUri);

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> logout() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      String? deviceId;

      if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor;
      } else if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.id;
      }

      final result = await clientPostData(AppConstants.logoutUri, {
        'device_id': deviceId.toString(),
      });

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> updateAvatar(List<MultipartBody> multipartBody) async {
    try {
      final result = await clientPostMultipartData(AppConstants.updateAvatarUri, {}, multipartBody);

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> updateProfile(Map<String, dynamic> params) async {
    try {
      final result = await clientPostData(AppConstants.updateProfileUri, params);

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> updateNewPassword(Map<String, dynamic> params) async {
    try {
      final result = await clientPostData(AppConstants.updateNewPasswordUri, params);

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> deleteAccount() async {
    try {
      final result = await clientDeleteData(AppConstants.deleteAccountUri);

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> endableSecurity(String securityPass) async {
    try {
      final result = await clientPostData(AppConstants.endableSecurityUri, {
        'security_pass': securityPass,
      });

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> disableSecurity(String securityPass) async {
    try {
      final result = await clientPostData(AppConstants.disableSecurityUri, {
        'security_pass': securityPass,
      });

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> changeSecurity(String securityPass) async {
    try {
      final result = await clientPostData(AppConstants.changeSecurityUri, {
        'new_security_pass': securityPass,
      });

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> syncContacts(Map<String, dynamic> params) async {
    try {
      final result = await clientPostData(AppConstants.syncContactsUri, params);

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> screenChangeSecurity(String securityPass) async {
    try {
      final result = await clientPostData(AppConstants.screenChangeSecurityUri, {
        'security_pass': securityPass,
      });

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> screenDisableSecurity(String securityPass) async {
    try {
      final result = await clientPostData(AppConstants.screenDisableSecurityUri, {
        'security_pass': securityPass,
      });

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }

  @override
  Future<Response> screenEndableSecurity(String securityPass) async {
    try {
      final result = clientPostData(AppConstants.screenEndableSecurityUri, {
        'security_pass': securityPass,
      });

      return result;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }
}
