import 'package:chats/models/profile/user_model.dart';
import 'package:chats/models/response/phone_code_model.dart';
import 'package:chats/pages/make_friends/make_friends_parameter.dart';
import 'package:chats/pages/profile/profile_controller.dart';
import 'package:chats/resourese/contact/icontact_repository.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/widget/dialog/noti_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class AddFriendController extends GetxController {
  final IContactRepository contactRepository;

  AddFriendController({required this.contactRepository});

  final TextEditingController phoneController = TextEditingController();

  final Rx<PhoneCodeModel> phoneCode = Rx(PhoneCodeModel());

  var isFormValid = false.obs;

  RxList<UserModel?> contactModel = <UserModel?>[].obs;

  @override
  void onInit() {
    super.onInit();
    phoneController.addListener(_validateForm);
  }

  void _validateForm() {
    isFormValid.value = phoneController.text.isNotEmpty;
  }

  void onSearchAccount() async {
    try {
      EasyLoading.show(dismissOnTap: false, maskType: EasyLoadingMaskType.clear);

      String phone = phoneController.text.trim();
      String numberWithCountryCode =
          PhoneCodeModel().getCodeAsString() + (phone.startsWith('0') ? phone.substring(1) : phone);

      final response = await contactRepository.searchContactPhone(numberWithCountryCode);

      if (response.statusCode == 200) {
        contactModel.value = UserModel.listFromJson(response.body['data']['data']);
        if (contactModel.isNotEmpty) {
          Get.toNamed(
            Routes.MAKE_FRIENDS,
            arguments: MakeFriendsParameter(
              id: contactModel[0]!.id!,
              contact: contactModel[0],
              type: MakeFriendsType.add,
            ),
          );
          phoneController.clear();
        } else {
          if (numberWithCountryCode == Get.find<ProfileController>().user.value?.phone) {
            showNotiDialog('cannot_search_for_your_own_phone_number'.tr);
          } else {
            showNotiDialog(response.body['message']);
          }
        }
      } else {
        showNotiDialog(response.body['message']);
      }
    } catch (e) {
      print(e);
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  void dispose() {
    super.dispose();
    phoneController
      ..dispose()
      ..removeListener(_validateForm);
  }
}
