import 'package:chats/models/request/sign_up_request.dart';
import 'package:chats/models/response/phone_code_model.dart';
import 'package:chats/pages/otp/otp_parameter.dart';
import 'package:chats/resourese/contact/icontact_repository.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/utils/app_enums.dart';
import 'package:chats/utils/custom_validator.dart';
import 'package:chats/utils/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  final IContactRepository contactRepository;

  SignUpController({required this.contactRepository});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  Rx<Gender?> selectGender = Rx<Gender?>(null);
  var isPolicyChecked = false.obs;

  var isFormValid = false.obs;
  var isLoading = false.obs;

  var phoneError = ''.obs;
  var emailError = ''.obs;
  var passwordError = ''.obs;
  var showPassword = ''.obs;

  @override
  void onInit() {
    super.onInit();
    nameController.addListener(_validateForm);
    phoneController.addListener(_validateForm);
    passwordController.addListener(_validateForm);
    selectGender.listen((_) => _validateForm());
    isPolicyChecked.listen((_) => _validateForm());
  }

  void _validateForm() {
    isFormValid.value = CustomValidator.validateName(nameController.text).isEmpty &&
        CustomValidator.validatePhone(phoneController.text).isEmpty &&
        CustomValidator.validatePassword(passwordController.text).isEmpty &&
        CustomValidator.validateAddress(addressController.text).isEmpty &&
        selectGender.value != null &&
        isPolicyChecked.value;
  }

  final Rx<PhoneCodeModel> phoneCode = Rx(PhoneCodeModel());

  void validatePhone(String text) {
    phoneError.value = '';
  }

  void validateEmail(String text) {
    emailError.value = '';
  }

  void validatePassword(String text) {
    passwordError.value = '';
  }

  void saveGender(Gender gender) {
    selectGender.value = gender;
  }

  void confirm() async {
    try {
      clearError();
      isLoading.value = true;

      String name = nameController.text.trim();
      String phone = phoneController.text.trim();
      String password = passwordController.text.trim();

      String numberWithCountryCode = phoneCode.value.getCodeAsString() + phone;
      PhoneValid phoneValid = await CustomValidator.isPhoneValid(numberWithCountryCode);
      numberWithCountryCode = phoneValid.phone;

      SignUpRequest params = SignUpRequest(
        name: name,
        phone: numberWithCountryCode,
        password: password,
        confirmPassword: password,
        birthday: '2000-01-11',
        gender: selectGender.value?.name ?? '',
        address: addressController.text,
      );

      final response = await contactRepository.findAccount(numberWithCountryCode);

      if (response.statusCode == 400 && (response.body['data'] is List && response.body['data'].isEmpty)) {
        Get.toNamed(
          Routes.OTP,
          arguments: OtpParameter(type: OtpType.signUp, contact: phone, signUpRequest: params),
        );
      } else if (response.statusCode == 200) {
        DialogUtils.showErrorDialog('the_phone_number_already_exists'.tr);
      } else {
        DialogUtils.showErrorDialog('account_creation_failed'.tr);
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  void clearError() {
    phoneError.value = '';
    emailError.value = '';
    passwordError.value = '';
  }

  @override
  void dispose() {
    nameController
      ..removeListener(_validateForm)
      ..clear()
      ..dispose();
    phoneController
      ..removeListener(_validateForm)
      ..clear()
      ..dispose();
    passwordController
      ..removeListener(_validateForm)
      ..clear()
      ..dispose();

    super.dispose();
  }

  @override
  void onClose() {
    nameController
      ..removeListener(_validateForm)
      ..clear()
      ..dispose();
    phoneController
      ..removeListener(_validateForm)
      ..clear()
      ..dispose();
    passwordController
      ..removeListener(_validateForm)
      ..clear()
      ..dispose();

    super.onClose();
  }
}
