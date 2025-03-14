import 'dart:async';

import 'package:chats/models/contact/contact_model.dart';
import 'package:chats/models/contact/friend_request.dart';
import 'package:chats/models/profile/user_model.dart';
import 'package:chats/pages/call/call_parameter.dart';
import 'package:chats/pages/message/message_parameter.dart';
import 'package:chats/resourese/contact/icontact_repository.dart';
import 'package:chats/resourese/messages/imessages_repository.dart';
import 'package:chats/routes/pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class ContactsController extends GetxController with GetSingleTickerProviderStateMixin {
  final IContactRepository contactRepository;
  final IMessagesRepository messagesRepository;

  ContactsController({required this.contactRepository, required this.messagesRepository});

  late final TabController tabController;

  var isLoading = false.obs;

  Rx<ContactModelData?> contactModel = Rx<ContactModelData?>(null);
  Rx<FriendRequestData?> friendRequest = Rx<FriendRequestData?>(null);

  @override
  void onInit() async {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    getContacts();
  }

  Future<void> getContacts({bool isRefresh = true}) async {
    try {
      if (isRefresh) isLoading.value = true;

      final response = await contactRepository.getContactAccepted(
        page: isRefresh ? 1 : (contactModel.value?.page ?? 1) + 1,
        limit: 10,
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
      }
    } catch (e) {
      print(e);
    } finally {
      if (isRefresh) {
        isLoading.value = false;
        _fetchOnReceived();
      }
    }
  }

  Future<void> _fetchOnReceived({bool isRefresh = true}) async {
    try {
      final response = await contactRepository.getReceived(
        page: isRefresh ? 1 : (friendRequest.value?.totalPage ?? 1) + 1,
        limit: 10,
      );

      if (response.statusCode == 200) {
        friendRequest.value = FriendRequestData.fromJson(response.body['data']);
      }
    } catch (e) {
      print(e);
    }
  }

  void removeContact(int id) {
    contactModel.value?.data?.removeWhere((element) => element.friend?.id == id);
    contactModel.refresh();
  }

  void updateContact(UserModel contact) {
    if (contactModel.value == null || contactModel.value!.data == null) {
      return;
    }

    bool isExist = contactModel.value!.data!.any(
      (element) => element.friend?.id == contact.id,
    );

    if (!isExist) {
      contactModel.value!.data!.insert(0, ContactModel(friend: contact..isFriend = true));
      contactModel.refresh();
    }
  }

  void onMessage(int id, {required ContactModel contact}) async {
    try {
      EasyLoading.show(dismissOnTap: false, maskType: EasyLoadingMaskType.clear);

      final response = await messagesRepository.getIdChatByUser(id);

      if (response.statusCode == 200) {
        Get.toNamed(
          Routes.CALL,
          arguments: CallCallParameter(
            id: contact.friend?.id ?? DateTime.now().millisecondsSinceEpoch,
            messageId: response.body['data']['id'],
            callId: null,
            name: contact.friend?.name ?? '',
            avatar: contact.friend?.avatar ?? '',
            channel: 'channel',
            type: CallType.call,
          ),
        );
      } else {
        Get.toNamed(
          Routes.MESSAGE,
          arguments: MessageParameter(contact: contact.friend),
        );
      }
    } catch (e) {
      print(e);
    } finally {
      EasyLoading.dismiss();
    }
  }

  Map<String, List<ContactModel>> get groupedContacts {
    List<ContactModel> contacts = contactModel.value?.data ?? [];

    Map<String, List<ContactModel>> grouped = {};

    for (var contact in contacts) {
      String firstLetter =
          (contact.friend?.name ?? '').trim().isNotEmpty ? (contact.friend?.name ?? '').trim()[0].toUpperCase() : '#';

      if (!grouped.containsKey(firstLetter)) {
        grouped[firstLetter] = [];
      }
      grouped[firstLetter]!.add(contact);
    }

    var sortedKeys = grouped.keys.toList()..sort();

    return {for (var key in sortedKeys) key: grouped[key]!};
  }
}
