import 'package:chats/main.dart';
import 'package:chats/models/response/phone_code_model.dart';
import 'package:chats/resourese/profile/iprofile_repository.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/utils/dialog_utils.dart';
import 'package:chats/widget/custom_boder_button_widget.dart';
import 'package:chats/widget/custom_button.dart';
import 'package:chats/widget/line_widget.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class SyncContactController extends GetxController {
  final IProfileRepository profileRepository;

  SyncContactController({required this.profileRepository});

  final Rx<PhoneCodeModel> phoneCode = Rx(PhoneCodeModel());

  var isLoading = false.obs;

  void syncContacts() async {
    try {
      isLoading.value = true;
      PermissionStatus permissionStatus = await Permission.contacts.request();
      if (!permissionStatus.isGranted) {
        bool openSettings = await showDialog(
          context: Get.context!,
          builder: (context) {
            return Padding(
              padding: padding(horizontal: 16),
              child: Dialog(
                backgroundColor: appTheme.whiteColor,
                insetPadding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: padding(top: 16, left: 16, right: 16, bottom: 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('request_permission'.tr, style: StyleThemeData.size16Weight600()),
                      SizedBox(height: 12.h),
                      const LineWidget(),
                      SizedBox(height: 8.h),
                      Text(
                        'content_permission_contact'.tr,
                        style: StyleThemeData.size14Weight400(),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        children: [
                          Flexible(
                            child: CustomBorderButtonWidget(
                              buttonText: 'cancel'.tr,
                              color: appTheme.silverColor,
                              textColor: appTheme.blackColor,
                              onPressed: () => Navigator.pop(context, false),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Flexible(
                            child: CustomButton(
                              buttonText: 'open_settings'.tr,
                              color: appTheme.redColor,
                              onPressed: () => Navigator.pop(context, true),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );

        if (openSettings) {
          await openAppSettings();
        } else {
          DialogUtils.showErrorDialog('Quyền truy cập danh bạ không được cấp!');
        }
      }
      Iterable<Contact> rawContacts = await ContactsService.getContacts();

      List<Map<String, String>> formattedContacts = rawContacts.map((contact) {
        return {
          "contact_name": contact.displayName ?? "Không có tên",
          // "phone": (contact.phones?.isNotEmpty ?? false) ? contact.phones?.first.value ?? "" : "",
          "phone": (() {
            final rawPhone = contact.phones?.first.value ?? "";
            final phoneClean = rawPhone.replaceAll(' ', '');
            if (phoneClean.startsWith('+84') || phoneClean.startsWith('84')) {
              return phoneClean;
            } else if (phoneClean.startsWith('0')) {
              return '+84${phoneClean.substring(1)}';
            } else {
              return '+84$phoneClean';
            }
          })(),
        };
      }).toList();

      Map<String, dynamic> params = {
        "contacts": formattedContacts,
      };

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
}
