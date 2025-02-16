import 'package:chats/resourese/profile/iprofile_repository.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/utils/custom_validator.dart';
import 'package:chats/utils/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdatePasswordController extends GetxController {
  final IProfileRepository profileRepository;

  UpdatePasswordController({required this.profileRepository});

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController = TextEditingController();

  var isLoading = false.obs;
  var isFormValid = false.obs;
  var isHidePassword = true.obs;

  var showPassword = ''.obs;
  var passwordError = ''.obs;
  var confirmPasswordError = ''.obs;

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

  void updatePassword() async {
    try {
      isLoading.value = true;

      Map<String, dynamic> params = {
        'password': newPasswordController.text,
        'confirm_password': confirmNewPasswordController.text,
      };

      final response = await profileRepository.updateNewPassword(params);

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
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
  }
}
