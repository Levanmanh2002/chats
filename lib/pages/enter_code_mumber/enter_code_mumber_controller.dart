import 'package:chats/models/profile/user_model.dart';
import 'package:chats/pages/enter_code_mumber/enter_code_mumber_parameter.dart';
import 'package:chats/pages/profile/profile_controller.dart';
import 'package:chats/pages/security_code/security_code_controller.dart';
import 'package:chats/resourese/profile/iprofile_repository.dart';
import 'package:chats/utils/dialog_utils.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

enum StatusCode { none, confirm, change }

class EnterCodeMumberController extends GetxController {
  final IProfileRepository profileRepository;
  final EnterCodeMumberParameter parameter;

  EnterCodeMumberController({required this.profileRepository, required this.parameter});

  final int maxDigits = 4;
  final RxString inputNumber = ''.obs;
  final RxString inputNumberLocal = ''.obs;
  final RxList<bool> selectionStates = List<bool>.filled(4, false).obs;
  Rx<StatusCode> statusCode = StatusCode.none.obs;

  @override
  void onInit() {
    super.onInit();
    if (parameter.action == EnterCodeMumberAction.change) {
      statusCode.value = StatusCode.change;
    }
  }

  void addDigit(String digit) {
    if (inputNumber.value.length < maxDigits) {
      inputNumber.value += digit;
      int index = inputNumber.value.length - 1;
      selectionStates[index] = true;
      selectionStates.refresh();

      if (parameter.action == EnterCodeMumberAction.change) {
        if (inputNumber.value.length == maxDigits) {
          if (statusCode.value == StatusCode.none) {
            inputNumberLocal.value = inputNumber.value;
            resetCode();
            statusCode.value = StatusCode.confirm;
          } else if (statusCode.value == StatusCode.confirm) {
            if (inputNumberLocal.value == inputNumber.value) {
              onSubmitSecurity();
            } else {
              DialogUtils.showErrorDialog('passcodes_do_not_match'.tr);
              resetCode();
              statusCode.value = StatusCode.none;
            }
          } else if (statusCode.value == StatusCode.change) {
            if (parameter.user?.securityCode != inputNumber.value) {
              DialogUtils.showErrorDialog('the_old_code_is_incorrect_please_try_again'.tr);
              resetCode();
              statusCode.value = StatusCode.change;
            } else {
              DialogUtils.showSuccessDialog('enter_new_passcode'.tr);

              resetCode();
              statusCode.value = StatusCode.none;
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

      if (parameter.action == EnterCodeMumberAction.enable) {
        response = await profileRepository.endableSecurity(inputNumber.value);
      } else if (parameter.action == EnterCodeMumberAction.disable) {
        response = await profileRepository.disableSecurity(inputNumber.value);
      } else if (parameter.action == EnterCodeMumberAction.change) {
        response = await profileRepository.changeSecurity(inputNumber.value);
      }

      if (response != null && response.statusCode == 200) {
        DialogUtils.showSuccessDialog(response.body['message']);

        Get.find<SecurityCodeController>().updateProfile(UserModel.fromJson(response.body['data']));
        Get.find<ProfileController>().updateProfile(UserModel.fromJson(response.body['data']));

        Get.back();
      } else {
        DialogUtils.showErrorDialog(response?.body['message']);
        resetCode();
        statusCode.value = StatusCode.none;
      }
    } catch (e) {
      print(e);
    } finally {
      EasyLoading.dismiss();
    }
  }
}
