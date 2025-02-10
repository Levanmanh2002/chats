import 'package:chats/resourese/auth/auth_repository.dart';
import 'package:chats/resourese/auth/iauth_repository.dart';
import 'package:chats/resourese/contact/contact_repository.dart';
import 'package:chats/resourese/contact/icontact_repository.dart';
import 'package:chats/resourese/profile/iprofile_repository.dart';
import 'package:chats/resourese/profile/profile_repository.dart';
import 'package:get/get.dart';

class AppService {
  static Future<void> initAppService() async {
    Get.put<IAuthRepository>(AuthRepository());
    Get.put<IContactRepository>(ContactRepository());
    Get.put<IProfileRepository>(ProfileRepository());
  }
}
