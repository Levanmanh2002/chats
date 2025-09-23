import 'package:chats/models/tickers/tickers_model.dart';
import 'package:chats/pages/call/call_parameter.dart';
import 'package:chats/pages/chats/chats_page.dart';
import 'package:chats/pages/contacts/contacts_page.dart';
import 'package:chats/pages/home/home_page.dart';
import 'package:chats/pages/message/message_parameter.dart';
import 'package:chats/pages/notes/notes_page.dart';
import 'package:chats/pages/profile/profile_controller.dart';
import 'package:chats/pages/profile/profile_page.dart';
import 'package:chats/resourese/dashboard/idashboard_repository.dart';
import 'package:chats/resourese/messages/imessages_repository.dart';
import 'package:chats/resourese/service/socket_service.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/utils/local_storage.dart';
import 'package:chats/utils/shared_key.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  final IDashboardRepository dashboardRepository;
  final IMessagesRepository messagesRepository;

  DashboardController({required this.dashboardRepository, required this.messagesRepository});

  late PageController pageController;
  RxInt currentPage = 0.obs;
  RxInt unreadcount = 0.obs;

  List<Widget> pages = [
    HomePage(),
    NotesPage(),
    const SizedBox(),
    ChatsPage(),
    ContactsPage(),
    ProfilePage(),
  ];

  RxList<TickersModel> tickersModel = <TickersModel>[].obs;

  @override
  void onInit() async {
    super.onInit();
    pageController = PageController(initialPage: 0);
    _callEvent();
    _updateFcmToken();
    _fetchTickers();
  }

  void _callEvent() async {
    try {
      final extraData = await LocalStorage.getJSON(SharedKey.CALL_CHAT_EVENT);

      if (extraData != null) {
        Get.toNamed(
          Routes.CALL,
          arguments: CallCallParameter(
            id: int.tryParse(extraData['user_id'] ?? '') ?? 0,
            messageId: int.tryParse(extraData['id'] ?? '') ?? 0,
            callId: int.tryParse(extraData['call_id'] ?? '') ?? 0,
            name: extraData['user_name'] ?? '',
            avatar: extraData['user_avatar'] ?? '',
            channel: extraData['channel_name'] ?? '',
            token: extraData['call_token'] ?? '',
            type: CallType.incomingCall,
          ),
        );
      }
    } catch (e) {
      print(e);
    } finally {
      LocalStorage.remove(SharedKey.CALL_CHAT_EVENT);
    }
  }

  void animateToTab(int page) {
    currentPage.value = page;
    pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void goToTab(int page) {
    if (page == 2) {
      onClound(); 
      return;
    }
    currentPage.value = page;
    pageController.jumpToPage(page);
  }

  void backQuickMessage() {
    if (currentPage.value != 1) {
      goToTab(1);
    }
  }

  void onClound() async {
    try {
      EasyLoading.show(dismissOnTap: false, maskType: EasyLoadingMaskType.clear);

      final profile = Get.find<ProfileController>().user.value;
      if (profile == null) return;
      final response = await messagesRepository.getIdChatByUser(profile.id!);

      if (response.statusCode == 200) {
        Get.toNamed(
          Routes.MESSAGE,
          arguments: MessageParameter(chatId: response.body['data']['id'], contact: profile),
        );
      } else {
        Get.toNamed(
          Routes.MESSAGE,
          arguments: MessageParameter(contact: profile),
        );
      }
    } catch (e) {
      print(e);
    } finally {
      EasyLoading.dismiss();
    }
  }

  void _updateFcmToken() async {
    await dashboardRepository.updateFcmToken();
  }

  void _fetchTickers() async {
    try {
      final response = await dashboardRepository.getTickers();
      if (response.statusCode == 200) {
        tickersModel.value = TickersModel.listFromJson(response.body['data']['data']);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    // PusherService.disconnect();
    SocketService().disconnect();
    super.dispose();
  }
}
