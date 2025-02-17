import 'package:chats/pages/chats/chats_controller.dart';
import 'package:chats/pages/contacts/contacts_controller.dart';
import 'package:chats/pages/dashboard/dashboard_controller.dart';
import 'package:chats/pages/profile/profile_controller.dart';
import 'package:get/get.dart';

class DashboardBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(DashboardController(dashboardRepository: Get.find()));
    Get.put(ChatsController(chatsRepository: Get.find(), messagesRepository: Get.find()));
    Get.put(ContactsController(contactRepository: Get.find()));
    Get.put(ProfileController(profileRepository: Get.find()));
  }
}
