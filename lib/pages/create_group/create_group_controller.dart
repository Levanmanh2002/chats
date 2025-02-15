import 'package:chats/models/contact/contact_model.dart';
import 'package:chats/models/groups/group.dart';
import 'package:chats/pages/chats/chats_controller.dart';
import 'package:chats/pages/contacts/contacts_controller.dart';
import 'package:chats/pages/create_group/create_group_parameter.dart';
import 'package:chats/pages/group_message/group_message_parameter.dart';
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
      contactModel.value = Get.find<ContactsController>().contactModel.value;
      // parameter.users?.map((e) {

      // });
    } else {
      await getContacts();
      // if (parameter.users != null) {
      //   for (var element in parameter.users!) {
      //     selectContact(ContactModel(friend: element));
      //   }
      // }
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

        contactModel.value = ContactModelData(
          data: [
            if (!isRefresh) ...(contactModel.value?.data ?? []),
            ...(model.data ?? []),
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
          arguments: GroupMessageParameter(groupModel: groupModel.value),
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
