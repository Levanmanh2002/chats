import 'package:chats/pages/add_friend/add_friend_binding.dart';
import 'package:chats/pages/add_friend/add_friend_page.dart';
import 'package:chats/pages/attachment_fullscreen/attachment_fullscreen_binding.dart';
import 'package:chats/pages/attachment_fullscreen/attachment_fullscreen_page.dart';
import 'package:chats/pages/change_password/change_password_binding.dart';
import 'package:chats/pages/change_password/change_password_page.dart';
import 'package:chats/pages/create_group/create_group_binding.dart';
import 'package:chats/pages/create_group/create_group_page.dart';
import 'package:chats/pages/dashboard/dashboard_binding.dart';
import 'package:chats/pages/dashboard/dashboard_page.dart';
import 'package:chats/pages/forgot_password/forgot_password_binding.dart';
import 'package:chats/pages/forgot_password/forgot_password_page.dart';
import 'package:chats/pages/html_app/html_app_binding.dart';
import 'package:chats/pages/html_app/html_app_page.dart';
import 'package:chats/pages/make_friends/make_friends_binding.dart';
import 'package:chats/pages/make_friends/make_friends_page.dart';
import 'package:chats/pages/message/message_binding.dart';
import 'package:chats/pages/message/message_page.dart';
import 'package:chats/pages/otp/otp_binding.dart';
import 'package:chats/pages/otp/otp_page.dart';
import 'package:chats/pages/sent_request_contact/sent_request_contact_binding.dart';
import 'package:chats/pages/sent_request_contact/sent_request_contact_page.dart';
import 'package:chats/pages/sign_in/sign_in_binding.dart';
import 'package:chats/pages/sign_in/sign_in_page.dart';
import 'package:chats/pages/sign_up/sign_up_binding.dart';
import 'package:chats/pages/sign_up/sign_up_page.dart';
import 'package:chats/pages/splash/splash_binding.dart';
import 'package:chats/pages/splash/splash_page.dart';
import 'package:get/get.dart';

part 'routes.dart';

abstract class AppPages {
  static final pages = [
    GetPage(
      name: Routes.SPLASH,
      page: () => SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.SIGN_IN,
      page: () => SignInPage(),
      binding: SignInBinding(),
    ),
    GetPage(
      name: Routes.SIGN_UP,
      page: () => SignUpPage(),
      binding: SignUpBinding(),
    ),
    GetPage(
      name: Routes.DASHBOARD,
      page: () => DashboardPage(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: Routes.HTML,
      page: () => HtmlAppPage(),
      binding: HtmlAppBinding(),
    ),
    GetPage(
      name: Routes.FORGOT_PASSWORD,
      page: () => ForgotPasswordPage(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: Routes.OTP,
      page: () => OtpPage(),
      binding: OtpBinding(),
    ),
    GetPage(
      name: Routes.CHANGE_PASSWORD,
      page: () => ChangePasswordPage(),
      binding: ChangePasswordBinding(),
    ),
    GetPage(
      name: Routes.ADD_FRIEND,
      page: () => AddFriendPage(),
      binding: AddFriendBinding(),
    ),
    GetPage(
      name: Routes.CREATE_GROUP,
      page: () => CreateGroupPage(),
      binding: CreateGroupBinding(),
    ),
    GetPage(
      name: Routes.MAKE_FRIENDS,
      page: () => MakeFriendsPage(),
      binding: MakeFriendsBinding(),
    ),
    GetPage(
      name: Routes.SENT_REQUEST_CONTACT,
      page: () => SentRequestContactPage(),
      binding: SentRequestContactBinding(),
    ),
    GetPage(
      name: Routes.MESSAGE,
      page: () => MessagePage(),
      binding: MessageBinding(),
    ),
    GetPage(
      name: Routes.ATTACHMENT_FULLSCREEN,
      page: () => AttachmentFullscreenPage(),
      binding: AttachmentFullscreenBinding(),
    ),
  ];
}
