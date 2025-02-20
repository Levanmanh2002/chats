import 'package:chats/models/contact/contact_model.dart';
import 'package:chats/models/profile/user_model.dart';
import 'package:chats/resourese/contact/icontact_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactsController extends GetxController with GetSingleTickerProviderStateMixin {
  final IContactRepository contactRepository;

  ContactsController({required this.contactRepository});

  late final TabController tabController;

  var isLoading = false.obs;

  Rx<ContactModelData?> contactModel = Rx<ContactModelData?>(null);

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    getContacts();
  }

  Future<void> getContacts({bool isRefresh = true}) async {
    try {
      if (isRefresh) isLoading.value = true;

      final response = await contactRepository.getContactAccepted(
        page: isRefresh ? 1 : (contactModel.value?.totalPage ?? 1) + 1,
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
      if (isRefresh) isLoading.value = false;
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
      contactModel.value!.data!.add(ContactModel(friend: contact));
      contactModel.refresh();
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
