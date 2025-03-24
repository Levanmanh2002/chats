import 'package:chats/routes/pages.dart';
import 'package:chats/utils/dialog_utils.dart';
import 'package:chats/utils/local_storage.dart';
import 'package:chats/utils/shared_key.dart';
import 'package:get/get.dart';

class ConfirmSecurityCodeController extends GetxController {
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

  void confirmCode() async {
    final securityCode = LocalStorage.getString(SharedKey.SECURITY_CODE);

    if (inputNumber.value == securityCode) {
      Get.offAllNamed(Routes.DASHBOARD);
    } else {
      DialogUtils.showErrorDialog('security_code_is_invalid'.tr);
      resetCode();
    }
  }
}
