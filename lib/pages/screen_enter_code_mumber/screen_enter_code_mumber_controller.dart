import 'package:chats/models/profile/user_model.dart';
import 'package:chats/pages/profile/profile_controller.dart';
import 'package:chats/pages/screen_enter_code_mumber/screen_enter_code_mumber_parameter.dart';
import 'package:chats/pages/screen_security_code/screen_security_code_controller.dart';
import 'package:chats/resourese/profile/iprofile_repository.dart';
import 'package:chats/utils/dialog_utils.dart';
import 'package:chats/utils/local_storage.dart';
import 'package:chats/utils/shared_key.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

enum ScreenStatusCode { none, confirm, change }

class ScreenEnterCodeMumberController extends GetxController {
  final IProfileRepository profileRepository;
  final ScreenEnterCodeMumberParameter parameter;

  ScreenEnterCodeMumberController({required this.profileRepository, required this.parameter});

  final int maxDigits = 4;
  final RxString inputNumber = ''.obs;
  final RxString inputNumberLocal = ''.obs;
  final RxList<bool> selectionStates = List<bool>.filled(4, false).obs;
  Rx<ScreenStatusCode> statusCode = ScreenStatusCode.none.obs;

  @override
  void onInit() {
    super.onInit();
    if (parameter.action == ScreenEnterCodeMumberAction.change) {
      statusCode.value = ScreenStatusCode.change;
    }
  }

  void addDigit(String digit) {
    if (inputNumber.value.length < maxDigits) {
      inputNumber.value += digit;
      int index = inputNumber.value.length - 1;
      selectionStates[index] = true;
      selectionStates.refresh();

      if (parameter.action == ScreenEnterCodeMumberAction.change) {
        if (inputNumber.value.length == maxDigits) {
          if (statusCode.value == ScreenStatusCode.none) {
            inputNumberLocal.value = inputNumber.value;
            resetCode();
            statusCode.value = ScreenStatusCode.confirm;
          } else if (statusCode.value == ScreenStatusCode.confirm) {
            if (inputNumberLocal.value == inputNumber.value) {
              onSubmitSecurity();
            } else {
              DialogUtils.showErrorDialog('passcodes_do_not_match'.tr);
              resetCode();
              statusCode.value = ScreenStatusCode.none;
            }
          } else if (statusCode.value == ScreenStatusCode.change) {
            if (parameter.user?.securityCodeScreen != inputNumber.value) {
              DialogUtils.showErrorDialog('the_old_code_is_incorrect_please_try_again'.tr);
              resetCode();
              statusCode.value = ScreenStatusCode.change;
            } else {
              DialogUtils.showSuccessDialog('enter_new_passcode'.tr);

              resetCode();
              statusCode.value = ScreenStatusCode.none;
            }
          }
        }
      } else {
        if (inputNumber.value.length == maxDigits) {
          onSubmitSecurity();
        }
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

  void onSubmitSecurity() async {
    try {
      EasyLoading.show(dismissOnTap: false, maskType: EasyLoadingMaskType.clear);

      Response<dynamic>? response;

      if (parameter.action == ScreenEnterCodeMumberAction.enable) {
        response = await profileRepository.screenEndableSecurity(inputNumber.value);
      } else if (parameter.action == ScreenEnterCodeMumberAction.disable) {
        response = await profileRepository.screenDisableSecurity(inputNumber.value);
      } else if (parameter.action == ScreenEnterCodeMumberAction.change) {
        response = await profileRepository.screenChangeSecurity(inputNumber.value);
      }

      if (response != null && response.statusCode == 200) {
        DialogUtils.showSuccessDialog(response.body['message']);

        Get.find<ScreenSecurityCodeController>().updateProfile(UserModel.fromJson(response.body['data']));
        Get.find<ProfileController>().updateProfile(UserModel.fromJson(response.body['data']));

        if (parameter.action == ScreenEnterCodeMumberAction.enable) {
          updateLocalCode();
        } else if (parameter.action == ScreenEnterCodeMumberAction.change) {
          updateLocalCode();
        } else if (parameter.action == ScreenEnterCodeMumberAction.disable) {
          removeLocalCode();
        }

        Get.back();
      } else {
        DialogUtils.showErrorDialog(response?.body['message']);
        resetCode();
        statusCode.value = ScreenStatusCode.none;
      }
    } catch (e) {
      print(e);
    } finally {
      EasyLoading.dismiss();
    }
  }

  void updateLocalCode() async {
    await LocalStorage.setBool(SharedKey.IS_SHOW_SECURITY_SCREEN, true);
    await LocalStorage.setString(SharedKey.SECURITY_CODE_SCREEN, inputNumber.value);
  }

  void removeLocalCode() async {
    await LocalStorage.setBool(SharedKey.IS_SHOW_SECURITY_SCREEN, false);
    await LocalStorage.remove(SharedKey.IS_SHOW_SECURITY_SCREEN);
    await LocalStorage.remove(SharedKey.SECURITY_CODE_SCREEN);
  }
}
