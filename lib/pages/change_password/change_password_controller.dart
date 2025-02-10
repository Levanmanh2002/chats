import 'package:chats/models/response/phone_code_model.dart';
import 'package:chats/pages/change_password/change_password_parameter.dart';
import 'package:chats/resourese/auth/iauth_repository.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/utils/custom_validator.dart';
import 'package:chats/utils/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordController extends GetxController {
  final IAuthRepository authRepository;
  final ChangePasswordParameter parameter;

  ChangePasswordController({required this.authRepository, required this.parameter});

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController = TextEditingController();
  final Rx<PhoneCodeModel> phoneCode = Rx(PhoneCodeModel());

  var isFormValid = false.obs;

  var isLoading = false.obs;

  var passwordError = ''.obs;
  var confirmPasswordError = ''.obs;
  var showPassword = ''.obs;

  @override
  void onInit() {
    super.onInit();
    newPasswordController.addListener(_validateForm);
    confirmNewPasswordController.addListener(_validateForm);
  }

  void _validateForm() {
    isFormValid.value = CustomValidator.validatePassword(newPasswordController.text).isEmpty &&
        confirmNewPasswordController.text == newPasswordController.text;
  }

  void validatePassword(String text) {
    passwordError.value = '';
  }

  void validateConfirmPassword(String text) {
    confirmPasswordError.value = '';
  }

  void onConfirm() async {
    try {
      isLoading.value = true;

      String numberWithCountryCode = phoneCode.value.getCodeAsString() + parameter.phone;
      PhoneValid phoneValid = await CustomValidator.isPhoneValid(numberWithCountryCode);
      numberWithCountryCode = phoneValid.phone;

      Map<String, String> params = {
        "phone": numberWithCountryCode,
        "password": newPasswordController.text.trim(),
        "confirm_password": confirmNewPasswordController.text.trim(),
        "otp_token": parameter.otpToken,
      };

      final response = await authRepository.updatePassword(params);

      if (response.statusCode == 200) {
        DialogUtils.showSuccessDialog(response.body['message']);
        Get.offAllNamed(Routes.SIGN_IN);
      } else {
        DialogUtils.showErrorDialog(response.body['message']);
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    newPasswordController
      ..removeListener(_validateForm)
      ..dispose();
    confirmNewPasswordController
      ..removeListener(_validateForm)
      ..dispose();
  }
}
