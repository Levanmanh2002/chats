import 'package:chats/models/chats/chat_data_model.dart';
import 'package:chats/models/contact/contact_model.dart';
import 'package:chats/models/profile/user_model.dart';
import 'package:chats/models/response/phone_code_model.dart';
import 'package:chats/pages/chats/chats_controller.dart';
import 'package:chats/pages/group_message/group_message_controller.dart';
import 'package:chats/pages/group_option/group_option_controller.dart';
import 'package:chats/pages/view_group_members/view_group_members_parameter.dart';
import 'package:chats/resourese/groups/igroups_repository.dart';
import 'package:chats/utils/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class ViewGroupMembersController extends GetxController {
  final ViewGroupMembersParameter parameter;
  final IGroupsRepository groupsRepository;

  ViewGroupMembersController({required this.parameter, required this.groupsRepository});

  Rx<ChatDataModel?> chatGroupData = Rx<ChatDataModel?>(null);

  final TextEditingController searchController = TextEditingController();

  final Rx<PhoneCodeModel> phoneCode = Rx(PhoneCodeModel());

  var chatValue = ''.obs;

  @override
  void onInit() {
    super.onInit();
    chatGroupData.value = parameter.chatGroup;
  }

  void clearSearch() {
    searchController.clear();
    chatValue.value = '';
  }

  String removeDiacritics(String str) {
    const withDia = 'ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơÇçÑñ';
    const withoutDia = 'AAAAEEEIII OOOOUUAĐIUOaaaaeeeiiioooouuađiuoCcNn';

    for (int i = 0; i < withDia.length; i++) {
      str = str.replaceAll(withDia[i], withoutDia[i]);
    }
    return str;
  }

  List<UserModel> get filteredUsers {
    final allUsers = chatGroupData.value?.users ?? [];
    if (chatValue.value.isEmpty) return allUsers;

    final query = removeDiacritics(chatValue.value).toLowerCase();

    return allUsers.where((user) {
      final nameNormalized = removeDiacritics(user.name ?? '').toLowerCase();
      final phoneNormalized = (user.phone ?? '').toLowerCase();

      return nameNormalized.contains(query) || phoneNormalized.contains(query);
    }).toList();
  }

  void removeMemberFromGroup(UserModel user) async {
    try {
      EasyLoading.show(dismissOnTap: false, maskType: EasyLoadingMaskType.clear);

      Map<String, dynamic> params = {
        "group_id": parameter.chatGroup?.id,
        "user_ids": [user.id],
      };

      final response = await groupsRepository.removeUserFromGroup(params);

      if (response.statusCode == 200) {
        DialogUtils.showSuccessDialog(response.body['message']);
        chatGroupData.value?.users?.remove(user);
        chatGroupData.refresh();
        Get.find<GroupOptionController>().removeUserInChatGroup(user);
        Get.find<GroupMessageController>().removeUserInChatGroup(user);
      } else {
        DialogUtils.showErrorDialog(response.body['message']);
      }
    } catch (e) {
      print(e);
    } finally {
      EasyLoading.dismiss();
    }
  }

  void addMemberToGroup(List<ContactModel> contactList) async {
    chatGroupData.value?.users?.addAll(contactList.map((e) => e.friend!));
    chatGroupData.refresh();
  }

  void transferOwnership(UserModel user) async {
    try {
      EasyLoading.show(dismissOnTap: false, maskType: EasyLoadingMaskType.clear);

      Map<String, dynamic> params = {
        "group_id": parameter.chatGroup?.id,
        "assign_owner_id": user.id,
      };

      final response = await groupsRepository.transferOwnership(params);

      if (response.statusCode == 200) {
        DialogUtils.showSuccessDialog(response.body['message']);
        Get.close(3);
        if (parameter.chatGroup != null) {
          Get.find<ChatsController>().removeChat(parameter.chatGroup!.id!);
        }
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
    searchController.dispose();
  }
}
