import 'package:chats/pages/chats/chats_page.dart';
import 'package:chats/pages/contacts/contacts_page.dart';
import 'package:chats/pages/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  late PageController pageController;
  RxInt currentPage = 0.obs;
  RxInt unreadcount = 0.obs;

  List<Widget> pages = [
    ChatsPage(),
    ContactsPage(),
    ProfilePage(),
  ];

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: 0);
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

  @override
  void dispose() {
    pageController.dispose();
    // PusherService.disconnect();
    super.dispose();
  }
}
