import 'package:chats/extension/data/gender_extension.dart';
import 'package:chats/extension/date_time_extension.dart';
import 'package:chats/models/profile/user_model.dart';
import 'package:chats/models/response/phone_code_model.dart';
import 'package:chats/pages/profile/profile_controller.dart';
import 'package:chats/pages/update_profile/update_profile_parameter.dart';
import 'package:chats/resourese/ibase_repository.dart';
import 'package:chats/resourese/profile/iprofile_repository.dart';
import 'package:chats/utils/app_enums.dart';
import 'package:chats/utils/custom_validator.dart';
import 'package:chats/utils/dialog_utils.dart';
import 'package:chats/utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfileController extends GetxController {
  final IProfileRepository profileRepository;
  final UpdateProfileParameter parameter;

  UserModel? get user => parameter.user;

  UpdateProfileController({required this.profileRepository, required this.parameter});

  final Rx<PhoneCodeModel> phoneCode = Rx(PhoneCodeModel());

  late TextEditingController nameController;
  late TextEditingController addressController;
  late TextEditingController autoMessage;

  Rx<Gender?> selectGender = Rx<Gender?>(null);
  var avatarFile = Rxn<XFile>();
  Rx<DateTime?> selectDate = Rx<DateTime?>(null);

  var isFormValid = false.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController(text: user?.name)..addListener(_validateForm);
    addressController = TextEditingController(text: user?.address)..addListener(_validateForm);
    autoMessage = TextEditingController(text: user?.autoMessage ?? '');
    selectGender.value = user?.gender?.nameValue;
    selectDate.value = user?.birthday?.toDateTime;
    selectGender.listen((_) => _validateForm());
    selectDate.listen((_) => _validateForm());

    _validateForm();
  }

  void _validateForm() {
    isFormValid.value = CustomValidator.validateName(nameController.text).isEmpty &&
        CustomValidator.validateAddress(addressController.text).isEmpty &&
        selectGender.value != null &&
        selectDate.value != null;
  }

  void saveGender(Gender gender) {
    selectGender.value = gender;
  }

  void saveDate(DateTime? date) {
    selectDate.value = date;
  }

  void updateProfile() async {
    try {
      isLoading.value = true;

      Map<String, dynamic> params = {
        "name": nameController.text.trim(),
        "birthday": selectDate.value?.toyyyyMMdd ?? '',
        "gender": selectGender.value?.name ?? '',
        "address": addressController.text.trim(),
        "auto_message": autoMessage.text.trim(),
      };

      final response = await profileRepository.updateProfile(params);

      if (response.statusCode == 200) {
        DialogUtils.showSuccessDialog(response.body['message']);
        Get.find<ProfileController>().updateProfile(UserModel.fromJson(response.body['data']));
        Get.back();
      } else {
        DialogUtils.showErrorDialog(response.body['message']);
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  void pickImageAvatar() async {
    avatarFile.value = await ImageUtils.pickImage();

    if (avatarFile.value != null) {
      updateAvatar();
    }
  }

  void updateAvatar() async {
    try {
      EasyLoading.show(dismissOnTap: false, maskType: EasyLoadingMaskType.clear);

      List<MultipartBody> multipartBody = [
        MultipartBody('avatar', avatarFile.value),
      ];

      final response = await profileRepository.updateAvatar(multipartBody);

      if (response.statusCode == 200) {
        DialogUtils.showSuccessDialog(response.body['message']);
        Get.find<ProfileController>().updateProfile(UserModel.fromJson(response.body['data']));
        Get.back();
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
    nameController
      ..dispose()
      ..removeListener(_validateForm);
    addressController
      ..dispose()
      ..removeListener(_validateForm);
  }
}
