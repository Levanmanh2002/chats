import 'package:chats/models/chats/chat_data_model.dart';
import 'package:chats/models/profile/user_model.dart';
import 'package:chats/pages/chats/chats_controller.dart';
import 'package:chats/pages/group_message/group_message_controller.dart';
import 'package:chats/pages/group_option/group_option_parameter.dart';
import 'package:chats/resourese/groups/igroups_repository.dart';
import 'package:chats/utils/dialog_utils.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class GroupOptionController extends GetxController {
  final IGroupsRepository groupsRepository;
  final GroupOptionParameter parameter;

  GroupOptionController({required this.groupsRepository, required this.parameter});

  Rx<ChatDataModel?> chatDataModel = Rx<ChatDataModel?>(null);

  @override
  void onInit() {
    chatDataModel.value = parameter.chat;
    super.onInit();
  }

  Future<void> renameGroup(String groupName) async {
    try {
      if (parameter.chat == null) return;
      EasyLoading.show(dismissOnTap: false, maskType: EasyLoadingMaskType.clear);

      final response = await groupsRepository.renameGroup(parameter.chat!.id!, groupName);

      if (response.statusCode == 200) {
        chatDataModel.value?.name = groupName;
        chatDataModel.refresh();
        Get.find<GroupMessageController>().updateGroupName(groupName);
        Get.find<ChatsController>().updateGroupName(parameter.chat!.id!, groupName);
      } else {
        DialogUtils.showErrorDialog(response.body['message']);
      }
    } catch (e) {
      print(e);
    } finally {
      EasyLoading.dismiss();
    }
  }

  void removeUserInChatGroup(UserModel user) {
    chatDataModel.value?.users?.remove(user);
    chatDataModel.refresh();
  }

  void updateNewDataUserChat(ChatDataModel chat) {
    chatDataModel.value = chatDataModel.value?.copyWith(users: chat.users);
    chatDataModel.refresh();
  }
}
