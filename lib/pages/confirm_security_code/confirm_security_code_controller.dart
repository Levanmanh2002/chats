import 'package:chats/models/profile/user_model.dart';
import 'package:chats/resourese/profile/iprofile_repository.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/utils/dialog_utils.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class ConfirmSecurityCodeController extends GetxController {
  final IProfileRepository profileRepository;

  ConfirmSecurityCodeController({required this.profileRepository});

  Rx<UserModel?> user = Rx<UserModel?>(null);

  final int maxDigits = 4;

  final RxString inputNumber = ''.obs;
  final RxList<bool> selectionStates = List<bool>.filled(4, false).obs;

  void addDigit(String digit) {
    if (inputNumber.value.length < maxDigits) {
      inputNumber.value += digit;
      int index = inputNumber.value.length - 1;
      selectionStates[index] = true;
      selectionStates.refresh();

      if (inputNumber.value.length == maxDigits) {
        confirmCode();
      }
    }
  }

  void deleteLast() {
    if (inputNumber.value.isNotEmpty) {
      int lastIndex = inputNumber.value.length - 1;
      inputNumber.value = inputNumber.value.substring(0, lastIndex);
      selectionStates[lastIndex] = false;
      selectionStates.refresh();
    }
  }

  void resetCode() {
    inputNumber.value = '';
    selectionStates.fillRange(0, maxDigits, false);
  }

  // void confirmCode() async {
  //   final securityCode = LocalStorage.getString(SharedKey.SECURITY_CODE_SCREEN);

  //   if (inputNumber.value == securityCode) {
  //     Get.offAllNamed(Routes.DASHBOARD);
  //   } else {
  //     DialogUtils.showErrorDialog('security_code_is_invalid'.tr);
  //     resetCode();
  //   }
  // }

  void confirmCode() async {
    try {
      EasyLoading.show(dismissOnTap: false, maskType: EasyLoadingMaskType.clear);

      final response = await profileRepository.profile();

      if (response.isOk) {
        user.value = UserModel.fromJson(response.body['data']);

        if (user.value != null && (user.value?.securityCodeScreen ?? '').isNotEmpty) {
          if (inputNumber.value == user.value?.securityCodeScreen) {
            Get.offAllNamed(Routes.DASHBOARD);
          } else {
            DialogUtils.showErrorDialog('security_code_is_invalid'.tr);
            resetCode();
          }
        }
      } else {
        DialogUtils.showErrorDialog('security_code_is_invalid'.tr);
        resetCode();
      }
    } catch (e) {
      print(e);
    } finally {
      EasyLoading.dismiss();
    }
  }

  void onViewSkipToSign() async {
    Get.offAllNamed(Routes.SIGN_IN);
  }
}
