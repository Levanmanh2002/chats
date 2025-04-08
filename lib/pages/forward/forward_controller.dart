import 'package:chats/models/chats/chat_data_model.dart';
import 'package:chats/models/chats/chats_models.dart';
import 'package:chats/pages/chats/chats_controller.dart';
import 'package:chats/pages/forward/forward_parameter.dart';
import 'package:chats/pages/profile/profile_controller.dart';
import 'package:chats/resourese/chats/ichats_repository.dart';
import 'package:chats/utils/dialog_utils.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class ForwardController extends GetxController {
  final IChatsRepository chatsRepository;
  final ForwardParameter parameter;

  ForwardController({required this.chatsRepository, required this.parameter});

  var isLoading = false.obs;
  Rx<ChatsModels?> chatsModels = Rx<ChatsModels?>(null);
  Rx<ChatDataModel?> selectChatsModels = Rx<ChatDataModel?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchChatList();
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

  void onSendForwardMessage() {
    if (selectChatsModels.value?.isGroup == 1) {
      sendForwardGroupMessage();
    } else {
      sendForwardMessage();
    }
  }

  void sendForwardGroupMessage() async {
    if (selectChatsModels.value == null) return;

    try {
      EasyLoading.show(dismissOnTap: false, maskType: EasyLoadingMaskType.clear);

      final response = await chatsRepository.sendForwardGroupMessage(
        chatId: selectChatsModels.value!.id!,
        messageId: parameter.messageId!,
      );

      if (response.statusCode == 200) {
        DialogUtils.showSuccessDialog('forward_success'.tr);
        Get.find<ChatsController>().fetchChatList();
        Get.back(result: true);
      } else {
        DialogUtils.showErrorDialog(response.body['message']);
      }
    } catch (e) {
      print(e);
    } finally {
      EasyLoading.dismiss();
    }
  }

  void sendForwardMessage() async {
    if (selectChatsModels.value == null) return;

    try {
      EasyLoading.show(dismissOnTap: false, maskType: EasyLoadingMaskType.clear);

      final otherUsers =
          selectChatsModels.value?.users?.firstWhereOrNull((e) => e.id != Get.find<ProfileController>().user.value?.id);

      final response = await chatsRepository.sendForwardMessage(
        chatId: otherUsers!.id!,
        messageId: parameter.messageId!,
      );

      if (response.statusCode == 200) {
        DialogUtils.showSuccessDialog('forward_success'.tr);
        Get.find<ChatsController>().fetchChatList();
        Get.back(result: true);
      } else {
        DialogUtils.showErrorDialog(response.body['message']);
      }
    } catch (e) {
      print(e);
    } finally {
      EasyLoading.dismiss();
    }
  }

  void selectChat(ChatDataModel chat) {
    selectChatsModels.value = chat;
  }
}
