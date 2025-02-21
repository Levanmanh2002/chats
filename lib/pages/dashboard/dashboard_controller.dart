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
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: 0);
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
