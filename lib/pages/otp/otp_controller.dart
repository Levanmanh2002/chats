import 'dart:async';

import 'package:chats/models/request/sign_up_request.dart';
import 'package:chats/models/response/phone_code_model.dart';
import 'package:chats/pages/change_password/change_password_parameter.dart';
import 'package:chats/pages/otp/otp_parameter.dart';
import 'package:chats/resourese/auth/iauth_repository.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/utils/app_constants.dart';
import 'package:chats/utils/custom_validator.dart';
import 'package:chats/utils/dialog_utils.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class OtpController extends GetxController {
  final IAuthRepository authRepository;
  final OtpParameter parameter;

  OtpController({required this.authRepository, required this.parameter});

  final Rx<PhoneCodeModel> phoneCode = Rx(PhoneCodeModel());

  var verificationCode = ''.obs;
  var otpError = ''.obs;

  Timer? _timer;
  final seconds = Rx<int>(60);

  var isLoading = false.obs;
  var isLoadingRequestOTP = false.obs;

  @override
  void onInit() {
    super.onInit();
    requestOTP();
    startTimer();
  }

  void startTimer() {
    seconds.value = AppConstants.timeOtp;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      seconds.value = seconds.value - 1;
      if (seconds.value == 0) {
        timer.cancel();
        _timer?.cancel();
      }
      update();
    });
  }

  Future<void> onTapRequestOTP() async {
    if (seconds.value > 1) return;
    otpError.value = '';
    requestOTP();
  }

  Future<void> requestOTP() async {
    try {
      if (parameter.contact == null) return;
      EasyLoading.show(dismissOnTap: false, maskType: EasyLoadingMaskType.clear);

      String numberWithCountryCode = phoneCode.value.getCodeAsString() + parameter.contact!;
      PhoneValid phoneValid = await CustomValidator.isPhoneValid(numberWithCountryCode);
      numberWithCountryCode = phoneValid.phone;

      final response = await authRepository.requestOtp(numberWithCountryCode);

      if (response.statusCode == 200) {
        DialogUtils.showSuccessDialog(response.body['message']);
      }
    } catch (e) {
      print(e);
    } finally {
      startTimer();
      EasyLoading.dismiss();
    }
  }

  void updateVerificationCode(String value) {
    verificationCode.value = value;
    otpError.value = '';
  }

  void onConfirm() async {
    try {
      clearError();

      String numberWithCountryCode = phoneCode.value.getCodeAsString() + parameter.contact!;
      PhoneValid phoneValid = await CustomValidator.isPhoneValid(numberWithCountryCode);
      numberWithCountryCode = phoneValid.phone;

      isLoading.value = true;

      Map<String, String> params = {
        "phone": numberWithCountryCode,
        "otp_code": verificationCode.value,
      };

      Response<dynamic>? response;

      if (parameter.type == OtpType.forgotPassword) {
        response = await authRepository.verifyOtp(params);
      } else if (parameter.type == OtpType.signUp) {
        response = await authRepository.verifyOtp(params);
      }

      if (response?.statusCode == 200 || response?.statusCode == 201) {
        if (parameter.type == OtpType.signUp) {
          DialogUtils.showSuccessDialog(response?.body['message']);
          signUp(response?.body['data']['otp_token']);
        } else if (parameter.type == OtpType.forgotPassword) {
          DialogUtils.showSuccessDialog(response?.body['message']);
          Get.offNamed(
            Routes.CHANGE_PASSWORD,
            arguments: ChangePasswordParameter(
              phone: parameter.contact ?? '',
              otpToken: response?.body['data']['otp_token'],
            ),
          );
        }
      } else {
        DialogUtils.showErrorDialog(response?.body['message']);
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  void clearError() {
    otpError.value = '';
  }

  void signUp(String otpToken) async {
    try {
      EasyLoading.show(dismissOnTap: false, maskType: EasyLoadingMaskType.clear);

      SignUpRequest? signUpRequest = parameter.signUpRequest?.copyWith(otpToken: otpToken);

      if (signUpRequest == null) return;

      final response = await authRepository.signUp(signUpRequest);

      if (response.statusCode == 200) {
        DialogUtils.showSuccessDialog('account_registration_successful'.tr);
        Get.offAllNamed(Routes.SIGN_IN);
      } else {
        DialogUtils.showErrorDialog(response.body['message']);
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
    _timer?.cancel();
  }
}
