import 'package:chats/extension/string_extension.dart';
import 'package:chats/main.dart';
import 'package:chats/pages/otp/otp_controller.dart';
import 'package:chats/theme/style/style_theme.dart';
import 'package:chats/widget/custom_button.dart';
import 'package:chats/widget/default_app_bar.dart';
import 'package:chats/widget/input_formatter/number_onlyInput_formatter.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpPage extends GetWidget<OtpController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(),
      body: Padding(
        padding: padding(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('verify_otp_code'.tr, style: StyleThemeData.size24Weight600()),
            SizedBox(height: 4.h),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '${'otp_message'.tr} ',
                    style: StyleThemeData.size12Weight400(),
                  ),
                  TextSpan(
                      text: controller.parameter.contact?.maskedPhone ?? '', style: StyleThemeData.size12Weight600()),
                  TextSpan(text: ' ${'to_be_verified'.tr}', style: StyleThemeData.size12Weight400()),
                ],
              ),
            ),
            SizedBox(height: 50.h),
            Obx(() {
              final hasError = controller.otpError.value.isNotEmpty;
              return PinCodeTextField(
                length: 4,
                appContext: context,
                keyboardType: TextInputType.number,
                animationType: AnimationType.none,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(12),
                  fieldHeight: 61.w,
                  fieldWidth: 72.w,
                  borderWidth: 1,
                  errorBorderColor: appTheme.redColor,
                  selectedBorderWidth: 1,
                  activeBorderWidth: 1,
                  disabledBorderWidth: 1,
                  inactiveBorderWidth: 1,
                  errorBorderWidth: 1,
                  selectedColor: hasError ? appTheme.redColor : appTheme.silverColor,
                  selectedFillColor: appTheme.silverColor,
                  inactiveFillColor: appTheme.silverColor,
                  inactiveColor: appTheme.silverColor,
                  activeColor: hasError ? appTheme.redColor : appTheme.greenColor,
                  activeFillColor: hasError ? appTheme.redF5Color : appTheme.greenF3Color,
                ),
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                animationDuration: const Duration(milliseconds: 300),
                backgroundColor: appTheme.transparentColor,
                cursorColor: appTheme.appColor,
                textStyle: StyleThemeData.size16Weight600(color: hasError ? appTheme.redColor : null),
                enableActiveFill: true,
                onChanged: controller.updateVerificationCode,
                beforeTextPaste: (text) => true,
                inputFormatters: [
                  NumberOnlyInputFormatter(),
                  FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                ],
              );
            }),
            Obx(
              () {
                final errorText = controller.otpError.value;
                if (errorText.isEmpty) {
                  return const SizedBox();
                }
                return Center(
                  child: Padding(
                    padding: padding(top: 8),
                    child: Text(
                      errorText,
                      style: StyleThemeData.size12Weight400(color: appTheme.errorColor),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 50.h),
            Obx(
              () {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    (controller.seconds.value > 0)
                        ? RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'you_can_resend_code'.tr,
                                  style: StyleThemeData.size12Weight400(),
                                ),
                                TextSpan(
                                  text: ' ${controller.seconds.value} ',
                                  style: StyleThemeData.size12Weight600(color: appTheme.appColor),
                                ),
                                TextSpan(text: 'seconds'.tr, style: StyleThemeData.size12Weight400()),
                              ],
                            ),
                          )
                        : RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(text: 'didn_receive_the_code'.tr, style: StyleThemeData.size12Weight400()),
                                TextSpan(
                                  text: ' ${'resend_otp'.tr}',
                                  style: StyleThemeData.size12Weight600(color: appTheme.appColor),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = controller.isLoadingRequestOTP.isTrue ? null : controller.onTapRequestOTP,
                                ),
                              ],
                            ),
                          ),
                  ],
                );
              },
            ),
            SizedBox(height: 24.h),
            Obx(
              () => CustomButton(
                buttonText: 'confirm'.tr,
                isLoading: controller.isLoading.isTrue,
                onPressed: controller.verificationCode.value.length == 4 ? controller.onConfirm : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
