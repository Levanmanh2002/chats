import 'package:chats/models/response/phone_code_model.dart';
import 'package:chats/pages/otp/otp_parameter.dart';
import 'package:chats/resourese/contact/icontact_repository.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/utils/custom_validator.dart';
import 'package:chats/utils/dialog_utils.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  final IContactRepository contactRepository;

  ForgotPasswordController({required this.contactRepository});

  final Rx<PhoneCodeModel> phoneCode = Rx(PhoneCodeModel());

  final TextEditingController phoneController = TextEditingController();

  var isLoading = false.obs;
  var isFormValid = false.obs;

  var phoneError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    phoneController.addListener(_validateForm);
  }

  void _validateForm() {
    isFormValid.value = CustomValidator.validatePhone(phoneController.text).isEmpty;
  }

  void validatePhone(String text) {
    phoneError.value = '';
  }

  void onSubmit() async {
    try {
      isLoading.value = true;

      String phone = phoneController.text.trim();

      String numberWithCountryCode = phoneCode.value.getCodeAsString() + phone;
      PhoneValid phoneValid = await CustomValidator.isPhoneValid(numberWithCountryCode);
      numberWithCountryCode = phoneValid.phone;

      final response = await contactRepository.findAccount(numberWithCountryCode);

      if (response.statusCode == 200) {
        Get.toNamed(
          Routes.OTP,
          arguments: OtpParameter(
            type: OtpType.forgotPassword,
            contact: phoneController.text.trim(),
          ),
        );
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
    phoneController.dispose();
  }
}
