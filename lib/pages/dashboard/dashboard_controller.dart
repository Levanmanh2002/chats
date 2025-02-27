import 'package:chats/models/tickers/tickers_model.dart';
import 'package:chats/pages/chats/chats_page.dart';
import 'package:chats/pages/contacts/contacts_page.dart';
import 'package:chats/pages/profile/profile_page.dart';
import 'package:chats/resourese/dashboard/idashboard_repository.dart';
import 'package:chats/resourese/service/pusher_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  final IDashboardRepository dashboardRepository;

  DashboardController({required this.dashboardRepository});

  late PageController pageController;
  RxInt currentPage = 0.obs;
  RxInt unreadcount = 0.obs;

  List<Widget> pages = [
    ChatsPage(),
    ContactsPage(),
    ProfilePage(),
  ];

  RxList<TickersModel> tickersModel = <TickersModel>[].obs;

  @override
  void onInit() async {
    super.onInit();
    pageController = PageController(initialPage: 0);
    // final RemoteMessage? remoteMessage = await FirebaseMessaging.instance.getInitialMessage();

    // if (remoteMessage != null) {
    //   Get.toNamed(
    //     Routes.CALL,
    //     arguments: CallCallParameter(
    //       id: int.tryParse(remoteMessage.data['user_id'] ?? '') ?? 0,
    //       messageId: int.tryParse(remoteMessage.data['id'] ?? '') ?? 0,
    //       name: remoteMessage.data['user_name'] ?? '',
    //       avatar: remoteMessage.data['user_avatar'] ?? '',
    //       channel: remoteMessage.data['channel_name'] ?? '',
    //       token: remoteMessage.data['call_token'] ?? '',
    //       type: CallType.incomingCall,
    //     ),
    //   );
    // }

    _updateFcmToken();
    _fetchTickers();
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
    currentPage.value = page;
    pageController.jumpToPage(page);
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
    PusherService.disconnect();
    super.dispose();
  }
}
