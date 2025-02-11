import 'package:chats/models/contact/friend_request.dart';
import 'package:chats/pages/contacts/contacts_controller.dart';
import 'package:chats/resourese/contact/icontact_repository.dart';
import 'package:chats/utils/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class SentRequestContactController extends GetxController with GetSingleTickerProviderStateMixin {
  final IContactRepository contactRepository;

  SentRequestContactController({required this.contactRepository});

  late final TabController tabController;

  var isLoadingReceived = false.obs;
  var isLoadingSent = false.obs;
  var isLoadingCancel = false.obs;
  var isLoadingAccept = false.obs;

  Rx<FriendRequestData?> friendRequest = Rx<FriendRequestData?>(null);
  Rx<FriendRequestData?> friendSendt = Rx<FriendRequestData?>(null);

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    onReceived();
    onSend();
  }

  Future<void> onReceived({bool isRefresh = true}) async {
    try {
      if (isRefresh) isLoadingReceived.value = true;

      final response = await contactRepository.getReceived(
        page: isRefresh ? 1 : (friendRequest.value?.totalPage ?? 1) + 1,
        limit: 10,
      );

      if (response.statusCode == 200) {
        final model = FriendRequestData.fromJson(response.body['data']);

        friendRequest.value = FriendRequestData(
          data: [
            if (!isRefresh) ...(friendRequest.value?.data ?? []),
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
      if (isRefresh) isLoadingReceived.value = false;
    }
  }

  Future<void> onSend({bool isRefresh = true}) async {
    try {
      if (isRefresh) isLoadingSent.value = true;

      final response = await contactRepository.getSent(
        page: isRefresh ? 1 : (friendSendt.value?.totalPage ?? 1) + 1,
        limit: 10,
      );

      if (response.statusCode == 200) {
        final model = FriendRequestData.fromJson(response.body['data']);

        friendSendt.value = FriendRequestData(
          data: [
            if (!isRefresh) ...(friendSendt.value?.data ?? []),
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
      if (isRefresh) isLoadingSent.value = false;
    }
  }

  void removeFriend(int id) async {
    try {
      EasyLoading.show(dismissOnTap: false, maskType: EasyLoadingMaskType.clear);

      final response = await contactRepository.removeFriend(id);

      if (response.statusCode == 200) {
        DialogUtils.showSuccessDialog(response.body['message']);

        friendSendt.value?.data?.removeWhere((element) => element.id == id);
        friendSendt.refresh();
      } else {
        DialogUtils.showErrorDialog(response.body['message']);
      }
    } catch (e) {
      print(e);
    } finally {
      EasyLoading.dismiss();
    }
  }

  void cancelFriendRequest(int id) async {
    try {
      isLoadingCancel.value = true;

      final response = await contactRepository.cancelFriendRequest(id);

      if (response.statusCode == 200) {
        DialogUtils.showSuccessDialog(response.body['message']);

        friendRequest.value?.data?.removeWhere((element) => element.id == id);
        friendRequest.refresh();
      } else {
        DialogUtils.showErrorDialog(response.body['message']);
      }
    } catch (e) {
      print(e);
    } finally {
      isLoadingCancel.value = false;
    }
  }

  void acceptFriendRequest(int id) async {
    try {
      isLoadingAccept.value = true;

      final response = await contactRepository.acceptFriendRequest(id);

      if (response.statusCode == 200) {
        DialogUtils.showSuccessDialog(response.body['message']);
        Get.find<ContactsController>().getContacts();
        friendRequest.value?.data?.removeWhere((element) => element.id == id);
        friendRequest.refresh();
      } else {
        DialogUtils.showErrorDialog(response.body['message']);
      }
    } catch (e) {
      print(e);
    } finally {
      isLoadingAccept.value = false;
    }
  }

  void removeSent(int id) async {
    friendSendt.value?.data?.removeWhere((element) => element.id == id);
    friendSendt.refresh();
  }
}

extension GroupByMonth on List<FriendRequest> {
  Map<String, List<FriendRequest>> groupByMonth() {
    return fold<Map<String, List<FriendRequest>>>({}, (map, item) {
      if (item.createdAt == null) return map;
      final date = DateTime.parse(item.createdAt!);
      final key = 'Tháng ${date.month}/${date.year}';

      (map[key] ??= []).add(item);
      return map;
    });
  }
}
