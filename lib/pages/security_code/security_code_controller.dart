import 'package:chats/models/profile/user_model.dart';
import 'package:chats/pages/security_code/security_code_parameter.dart';
import 'package:get/get.dart';

class SecurityCodeController extends GetxController {
  final SecurityCodeParameter parameter;

  SecurityCodeController({required this.parameter});

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
