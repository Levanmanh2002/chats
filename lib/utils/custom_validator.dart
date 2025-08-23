import 'package:chats/utils/app_constants.dart';
import 'package:chats/utils/util.dart';
import 'package:get/get.dart';
import 'package:phone_number/phone_number.dart';

class CustomValidator {
  static final RegExp emailRegex = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  static final RegExp passwordRegex = RegExp(
      r'^(?!.*[ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯưĂâđêôơư])(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[#?!@$%^&*-])\S{8,}$');

  static Future<PhoneValid> isPhoneValid(String number) async {
    String phone = number;
    try {
      PhoneNumber phoneNumber = await PhoneNumberUtil().parse(number);
      phone = '+${phoneNumber.countryCode}${phoneNumber.nationalNumber}';

      return PhoneValid(isValid: true, phone: phone);
    } catch (e) {
      print(e);
      return PhoneValid(isValid: false, phone: phone);
    }
  }

  static String validatePhone(String email, {bool isRequired = true}) {
    if (isRequired && email.trim().isEmpty) {
      return 'field_is_required'.trParams({'field': 'phone_number'.tr});
    }
    if (isRequired && !Utils.isPhoneNumber(email)) {
      return 'field_is_invalid'.trParams({'field': 'phone_number'.tr});
    }
    return '';
  }

  static String validateName(String fullName) {
    if (fullName.trim().isEmpty) {
      return 'field_is_required'.trParams({'field': 'name'.tr});
    }
    if (fullName.trim().length < AppConstants.minNameLength || fullName.trim().length > AppConstants.maxNameLength) {
      return 'enter_full_field'.trParams({'field': 'name'.tr.toLowerCase()});
    }
    return '';
  }

  static String validatePassword(String password) {
    if (password.isEmpty) {
      return 'password_cannot_be_empty'.tr;
    } else if (password.length < 4) {
      return 'password_must_contain_at_least_4_characters'.tr;
    }
    // else if (!passwordRegex.hasMatch(password)) {
    //   return 'validate_password'.tr;
    // }
    return '';
  }

  static String validateEmail(String email, {bool isRequired = true}) {
    if (isRequired && email.trim().isEmpty) {
      return 'field_is_required'.trParams({'field': 'email'.tr});
    }
    if (isRequired && !emailRegex.hasMatch(email)) {
      return 'field_is_invalid'.trParams({'field': 'email'.tr});
    }
    return '';
  }

  static String validateAddress(String address) {
    if (address.trim().isEmpty) {
      return 'field_is_required'.trParams({'field': 'address'.tr});
    }
    if (address.trim().length < AppConstants.minAddressLength || address.trim().length > AppConstants.maxNameLength) {
      return 'enter_full_field'.trParams({'field': 'address'.tr.toLowerCase()});
    }
    return '';
  }
}

class PhoneValid {
  bool isValid;
  String phone;

  PhoneValid({required this.isValid, required this.phone});
}
