import 'package:chats/models/profile/user_model.dart';
import 'package:chats/pages/screen_security_code/screen_security_code_parameter.dart';
import 'package:get/get.dart';

class ScreenSecurityCodeController extends GetxController {
  final ScreenSecurityCodeParameter parameter;

  ScreenSecurityCodeController({required this.parameter});

  Rx<UserModel?> user = Rx<UserModel?>(null);

  @override
  void onInit() {
    super.onInit();
    user.value = parameter.user;
  }

  void updateProfile(UserModel newUser) {
    user.value = newUser;
    user.refresh();
  }
}
