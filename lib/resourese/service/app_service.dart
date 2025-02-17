import 'package:chats/resourese/auth/auth_repository.dart';
import 'package:chats/resourese/auth/iauth_repository.dart';
import 'package:chats/resourese/chats/chats_repository.dart';
import 'package:chats/resourese/chats/ichats_repository.dart';
import 'package:chats/resourese/contact/contact_repository.dart';
import 'package:chats/resourese/contact/icontact_repository.dart';
import 'package:chats/resourese/dashboard/dashboard_repository.dart';
import 'package:chats/resourese/dashboard/idashboard_repository.dart';
import 'package:chats/resourese/groups/groups_repository.dart';
import 'package:chats/resourese/groups/igroups_repository.dart';
import 'package:chats/resourese/messages/imessages_repository.dart';
import 'package:chats/resourese/messages/messages_repository.dart';
import 'package:chats/resourese/profile/iprofile_repository.dart';
import 'package:chats/resourese/profile/profile_repository.dart';
import 'package:get/get.dart';

class AppService {
  static Future<void> initAppService() async {
    Get.put<IAuthRepository>(AuthRepository());
    Get.put<IDashboardRepository>(DashboardRepository());
    Get.put<IContactRepository>(ContactRepository());
    Get.put<IProfileRepository>(ProfileRepository());
    Get.put<IMessagesRepository>(MessagesRepository());
    Get.put<IChatsRepository>(ChatsRepository());
    Get.put<IGroupsRepository>(GroupsRepository());
  }
}
