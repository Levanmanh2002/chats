import 'package:chats/models/chats/chat_data_model.dart';
import 'package:chats/models/contact/contact_model.dart';
import 'package:chats/models/groups/group.dart';
import 'package:chats/pages/chats/chats_controller.dart';
import 'package:chats/pages/contacts/contacts_controller.dart';
import 'package:chats/pages/create_group/create_group_parameter.dart';
import 'package:chats/pages/group_message/group_message_controller.dart';
import 'package:chats/pages/group_message/group_message_parameter.dart';
import 'package:chats/pages/group_option/group_option_controller.dart';
import 'package:chats/pages/view_group_members/view_group_members_controller.dart';
import 'package:chats/resourese/contact/icontact_repository.dart';
import 'package:chats/resourese/groups/igroups_repository.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/utils/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class CreateGroupController extends GetxController {
  final IContactRepository contactRepository;
  final IGroupsRepository groupsRepository;
  final CreateGroupParameter parameter;

  CreateGroupController({required this.contactRepository, required this.groupsRepository, required this.parameter});

  final TextEditingController groupNameController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  var isLoading = false.obs;

  Rx<ContactModelData?> contactModel = Rx<ContactModelData?>(null);
  RxList<ContactModel> selectedContacts = <ContactModel>[].obs;
  Rx<GroupModel?> groupModel = Rx<GroupModel?>(null);

  var chatValue = ''.obs;
  var createGroupValue = ''.obs;

  @override
  void onInit() async {
    super.onInit();

    if (Get.find<ContactsController>().contactModel.value != null) {
      final currentContacts = Get.find<ContactsController>().contactModel.value;

      if (parameter.type == CreateGroupType.joinGroup) {
        final filteredData = currentContacts?.data?.where((contact) {
          if (parameter.users == null || parameter.users!.isEmpty) return true;
          return !parameter.users!.any((user) => user.id == contact.friend?.id);
        }).toList();

        contactModel.value = currentContacts?.copyWith(data: filteredData);
      } else {
        contactModel.value = currentContacts;
      }
    } else {
      await getContacts();
    }

    if (parameter.type == CreateGroupType.createGroup && parameter.user != null) {
      final contacts = contactModel.value?.data ?? [];
      ContactModel? matchingContact;
      try {
        matchingContact = contacts.firstWhere((contact) => contact.friend?.id == parameter.user!.id);
      } catch (e) {
        matchingContact = null;
      }

      if (matchingContact != null && !selectedContacts.any((contact) => contact.id == matchingContact!.id)) {
        selectedContacts.add(matchingContact);
      }
    }
    updateSelectedContacts();
  }

  void updateSelectedContacts() {
    if (contactModel.value?.data == null || parameter.users == null) return;

    for (var contact in contactModel.value!.data!) {
      bool exists = parameter.users!.any((user) => user.id == contact.friend?.id);

      if (exists && !selectedContacts.any((selected) => selected.id == contact.friend?.id)) {
        selectedContacts.add(contact);
      }
    }
  }

  Future<void> getContacts({bool isRefresh = true, String search = ''}) async {
    try {
      if (isRefresh) isLoading.value = true;

      final response = await contactRepository.getContactAccepted(
        page: isRefresh ? 1 : (contactModel.value?.totalPage ?? 1) + 1,
        limit: 10,
        search: search,
      );

      if (response.statusCode == 200) {
        final model = ContactModelData.fromJson(response.body['data']);

        List<ContactModel> newData = model.data ?? [];

        if (parameter.type == CreateGroupType.joinGroup) {
          newData = newData.where((contact) {
            if (parameter.users == null || parameter.users!.isEmpty) return true;
            return !parameter.users!.any((user) => user.id == contact.friend?.id);
          }).toList();
        }

        contactModel.value = ContactModelData(
          data: [
            if (!isRefresh) ...(contactModel.value?.data ?? []),
            ...newData,
          ],
          totalPage: model.totalPage,
          totalCount: model.totalCount,
          page: model.page,
          size: model.size,
        );

        for (var newContact in model.data ?? []) {
          final index = selectedContacts.indexWhere((contact) => contact.id == newContact.id);
          if (index != -1) {
            selectedContacts[index] = newContact;
            selectedContacts.refresh();
          }
        }
      }
    } catch (e) {
      print(e);
    } finally {
      if (isRefresh) isLoading.value = false;
    }
  }

  void createGroup() async {
    if (selectedContacts.isEmpty) return;

    try {
      EasyLoading.show(dismissOnTap: false, maskType: EasyLoadingMaskType.clear);

      Map<String, dynamic> params = {
        'group_name': groupNameController.text.trim(),
        'user_ids': selectedContacts.map((e) => e.friend?.id).toList(),
      };

      final response = await groupsRepository.createGroup(params);

      if (response.statusCode == 200) {
        groupModel.value = GroupModel.fromJson(response.body['data']);
        Get.find<ChatsController>().fetchChatList();
        Get.offNamed(
          Routes.GROUP_MESSAGE,
          arguments: GroupMessageParameter(chatId: groupModel.value?.id),
        );
      } else {
        DialogUtils.showErrorDialog(response.body['message']);
      }
    } catch (e) {
      print(e);
    } finally {
      EasyLoading.dismiss();
    }
  }

  void addUserToGroup() async {
    if (selectedContacts.isEmpty) return;

    try {
      EasyLoading.show(dismissOnTap: false, maskType: EasyLoadingMaskType.clear);

      Map<String, dynamic> params = {
        'group_id': parameter.groupId,
        'user_ids': selectedContacts.map((e) => e.friend?.id).toList(),
      };

      final response = await groupsRepository.addUserToGroup(params);

      if (response.statusCode == 200) {
        DialogUtils.showSuccessDialog(response.body['message']);
        Get.find<GroupMessageController>().updateNewDataUserChat(ChatDataModel.fromJson(response.body['data']));
        Get.find<GroupOptionController>().updateNewDataUserChat(ChatDataModel.fromJson(response.body['data']));
        Get.back();
        if (parameter.updateAddMemberLocal == true) {
          Get.find<ViewGroupMembersController>().addMemberToGroup(selectedContacts);
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

  bool canDeleteContact(int contactId) {
    return !(parameter.users?.any((user) => user.id == contactId) ?? false);
  }

  void removeContact(ContactModel contact) {
    bool existsInCurrentUsers = parameter.users?.any((user) => user.id == contact.id) ?? false;

    if (!existsInCurrentUsers) selectedContacts.removeWhere((c) => c.id == contact.id);
  }

  void selectContact(ContactModel contact) {
    final index = selectedContacts.indexWhere((c) => c.id == contact.id);
    if (index != -1) {
      selectedContacts.removeAt(index);
    } else {
      selectedContacts.add(contact);
    }
  }

  void clearSearch() {
    searchController.clear();
    chatValue.value = '';
    getContacts();
  }

  @override
  void dispose() {
    super.dispose();
    groupNameController.dispose();
    searchController.dispose();
  }
}
