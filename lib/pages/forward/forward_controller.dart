import 'package:chats/models/chats/chat_data_model.dart';
import 'package:chats/models/chats/chats_models.dart';
import 'package:chats/models/contact/contact_model.dart';
import 'package:chats/pages/chats/chats_controller.dart';
import 'package:chats/pages/forward/forward_parameter.dart';
import 'package:chats/pages/profile/profile_controller.dart';
import 'package:chats/resourese/chats/ichats_repository.dart';
import 'package:chats/resourese/contact/icontact_repository.dart';
import 'package:chats/utils/dialog_utils.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

enum TabForward { chat, friend }

class ForwardController extends GetxController {
  final IChatsRepository chatsRepository;
  final IContactRepository contactRepository;
  final ForwardParameter parameter;

  ForwardController({required this.chatsRepository, required this.contactRepository, required this.parameter});

  var isLoading = false.obs;
  Rx<ChatsModels?> chatsModels = Rx<ChatsModels?>(null);
  RxList<ChatDataModel> selectChatsModels = <ChatDataModel>[].obs;

  Rx<TabForward> tabForward = Rx<TabForward>(TabForward.chat);

  Rx<ContactModelData?> contactModel = Rx<ContactModelData?>(null);
  RxList<ContactModel> selectContactModel = <ContactModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchChatList();
    fetchContacts();
  } 

  Future<void> fetchChatList({bool isRefresh = true, String search = '', bool isShowLoad = true}) async {
    try {
      if (isShowLoad && isRefresh) isLoading.value = true;

      final response = await chatsRepository.chatListAll(
        page: isRefresh ? 1 : (chatsModels.value?.page ?? 1) + 1,
        limit: 10,
        search: search,
      );

      if (response.statusCode == 200) {
        final model = ChatsModels.fromJson(response.body['data']);

        chatsModels.value = ChatsModels(
          chat: [
            if (!isRefresh) ...(chatsModels.value?.chat ?? []),
            ...(model.chat ?? []),
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
      if (isShowLoad && isRefresh) isLoading.value = false;
    }
  }

  Future<void> fetchContacts({bool isRefresh = true, bool isShowLoad = true}) async {
    try {
      if (isShowLoad && isRefresh) isLoading.value = true;

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
      if (isShowLoad && isRefresh) isLoading.value = false;
    }
  }

  void onSendForwardMessage() async {
    try {
      EasyLoading.show(dismissOnTap: false, maskType: EasyLoadingMaskType.clear);

      for (final chat in selectChatsModels) {
        final otherUsers = chat.users?.firstWhereOrNull((e) => e.id != Get.find<ProfileController>().user.value?.id);
        if (chat.isGroup == 1) {
          await sendForwardGroupMessage(chat.id);
        } else {
          await sendForwardMessage(otherUsers?.id);
        }
      }

      for (final contact in selectContactModel) {
        await sendForwardMessage(contact.friend?.id);
      }
    } catch (e) {
      print(e);
    } finally {
      EasyLoading.dismiss();
      DialogUtils.showSuccessDialog('forward_success'.tr);
      Get.find<ChatsController>().fetchChatList();
      Get.find<ChatsController>().clearMessage();
      Get.back(result: true);
    }
  }

  Future<void> sendForwardGroupMessage(int? id) async {
    if (id == null) return;
    try {
      final response = await chatsRepository.sendForwardGroupMessage(
        chatId: id,
        messageId: parameter.messageId!,
      );

      if (response.statusCode == 200) {
        // DialogUtils.showSuccessDialog('forward_success'.tr);
        // Get.find<ChatsController>().fetchChatList();
        // Get.back(result: true);
      } else {
        DialogUtils.showErrorDialog(response.body['message']);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> sendForwardMessage(int? id) async {
    if (id == null) return;
    try {
      final response = await chatsRepository.sendForwardMessage(
        chatId: id,
        messageId: parameter.messageId!,
      );

      if (response.statusCode == 200) {
        // DialogUtils.showSuccessDialog('forward_success'.tr);
        // Get.find<ChatsController>().fetchChatList();
        // Get.back(result: true);
      } else {
        DialogUtils.showErrorDialog(response.body['message']);
      }
    } catch (e) {
      print(e);
    }
  }

  void selectChat(ChatDataModel chat) {
    if (selectChatsModels.contains(chat)) {
      selectChatsModels.remove(chat);
    } else {
      selectChatsModels.add(chat);
    }
  }

  void selectFrinend(ContactModel user) {
    if (selectContactModel.contains(user)) {
      selectContactModel.remove(user);
    } else {
      selectContactModel.add(user);
    }
  }
}
