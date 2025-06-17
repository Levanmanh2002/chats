import 'package:chats/models/response/phone_code_model.dart';
import 'package:chats/resourese/auth/iauth_repository.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/utils/custom_validator.dart';
import 'package:chats/utils/dialog_utils.dart';
import 'package:chats/utils/local_storage.dart';
import 'package:chats/utils/shared_key.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInController extends GetxController {
  final IAuthRepository authRepository;

  SignInController({required this.authRepository});

  final Rx<PhoneCodeModel> phoneCode = Rx(PhoneCodeModel());

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  var isFormValid = false.obs;
  var isLoading = false.obs;

  var phoneError = ''.obs;
  var passwordError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    phoneController.addListener(_validateForm);
    passwordController.addListener(_validateForm);
  }

  void _validateForm() {
    isFormValid.value =
        CustomValidator.validatePhone(phoneController.text).isEmpty && passwordController.text.isNotEmpty;
  }

  void validatePhone(String text) {
    phoneError.value = '';
  }

  void validatePassword(String text) {
    passwordError.value = '';
  }

  void onConfirm() async {
    try {
      validatePhone('');
      validatePassword('');
      isLoading.value = true;

      String phone = phoneController.text.trim();
      String password = passwordController.text.trim();

      String numberWithCountryCode = phoneCode.value.getCodeAsString() + phone;
      PhoneValid phoneValid = await CustomValidator.isPhoneValid(numberWithCountryCode);
      numberWithCountryCode = phoneValid.phone;

      Map<String, String> params = {
        "phone": numberWithCountryCode,
        "password": password,
      };

      final response = await authRepository.signIn(params);

      if (response.statusCode == 200) {
        DialogUtils.showSuccessDialog('login_successful'.tr);
        await LocalStorage.setString(SharedKey.token, response.body['data']['api_token']);
        LocalStorage.setBool(SharedKey.isLoggedIn, true);
        Get.offAllNamed(Routes.DASHBOARD);
      } else {
        DialogUtils.showErrorDialog(response.body['message'] ?? '');
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  void handleErrorResponse(Map<String, dynamic> errorResponse) {
    final errors = errorResponse['data'] ?? [];

    if (errors is List) {
      for (final error in errors) {
        if (error is Map<String, dynamic>) {
          final field = error['field'];
          final errorMsg = error['error_msg'];
          if (field == 'phone') {
            phoneError.value = errorMsg?.toString() ?? '';
          } else if (field == 'password') {
            passwordError.value = errorMsg?.toString() ?? '';
          }
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    phoneController
      ..removeListener(_validateForm)
      ..dispose();
    passwordController
      ..removeListener(_validateForm)
      ..dispose();
  }
}
