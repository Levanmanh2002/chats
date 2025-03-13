import 'dart:developer';

import 'package:chats/models/response/phone_code_model.dart';
import 'package:chats/resourese/profile/iprofile_repository.dart';
import 'package:chats/utils/dialog_utils.dart';
import 'package:chats/widget/dialog/show_common_dialog.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class SyncContactController extends GetxController {
  final IProfileRepository profileRepository;

  SyncContactController({required this.profileRepository});

  final Rx<PhoneCodeModel> phoneCode = Rx(PhoneCodeModel());

  var isLoading = false.obs;

  static Future<List<Contact>> getDeviceContact() async {
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      return [];
    } else {
      return FlutterContacts.getContacts(withProperties: true);
    }
  }

  void syncContacts() async {
    try {
      isLoading.value = true;

      bool permissionGranted = await requestContactsPermission();
      if (permissionGranted == false) {
        DialogUtils.showErrorDialog("Quyền truy cập danh bạ không được cấp!");
        return;
      }

      final contact = await getDeviceContact();

      final validContacts = contact.where((contact) => contact.phones.isNotEmpty).toList();

      List<Map<String, String>> formattedContacts = validContacts.map((contact) {
        String name = contact.displayName;
        String rawPhone = contact.phones.first.number;
        final phoneClean = rawPhone.replaceAll(' ', '');
        String formattedPhone;
        if (phoneClean.startsWith('+84') || phoneClean.startsWith('84')) {
          formattedPhone = phoneClean;
        } else if (phoneClean.startsWith('0')) {
          formattedPhone = '+84${phoneClean.substring(1)}';
        } else {
          formattedPhone = '+84$phoneClean';
        }
        return {
          "contact_name": name,
          "phone": formattedPhone,
        };
      }).toList();

      Map<String, dynamic> params = {
        "contacts": formattedContacts,
      };

      log(params.toString());

      final response = await profileRepository.syncContacts(params);

      if (response.statusCode == 200) {
        DialogUtils.showSuccessDialog(response.body['message']);
        Get.back();
      } else {
        DialogUtils.showErrorDialog(response.body['message']);
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> requestContactsPermission() async {
    PermissionStatus permissionStatus = await Permission.contacts.request();
    if (!permissionStatus.isGranted && !permissionStatus.isPermanentlyDenied) {
      showCommonDialog(
        title: "Quyền truy cập danh bạ không được cấp!",
        buttonTitle: "Cấp quyền",
        onSubmit: () async {
          await openAppSettings();
        },
      );
      return false;
    }
    return true;
  }
}
