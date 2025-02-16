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
import 'package:chats/pages/enter_code_mumber/enter_code_mumber_binding.dart';
import 'package:chats/pages/enter_code_mumber/enter_code_mumber_page.dart';
import 'package:chats/pages/forgot_password/forgot_password_binding.dart';
import 'package:chats/pages/forgot_password/forgot_password_page.dart';
import 'package:chats/pages/group_message/group_message_binding.dart';
import 'package:chats/pages/group_message/group_message_page.dart';
import 'package:chats/pages/group_option/group_option_binding.dart';
import 'package:chats/pages/group_option/group_option_page.dart';
import 'package:chats/pages/html_app/html_app_binding.dart';
import 'package:chats/pages/html_app/html_app_page.dart';
import 'package:chats/pages/instant_message/instant_message_binding.dart';
import 'package:chats/pages/instant_message/instant_message_page.dart';
import 'package:chats/pages/make_friends/make_friends_binding.dart';
import 'package:chats/pages/make_friends/make_friends_page.dart';
import 'package:chats/pages/media_files/media_files_binding.dart';
import 'package:chats/pages/media_files/media_files_page.dart';
import 'package:chats/pages/message/message_binding.dart';
import 'package:chats/pages/message/message_page.dart';
import 'package:chats/pages/options/options_binding.dart';
import 'package:chats/pages/options/options_page.dart';
import 'package:chats/pages/otp/otp_binding.dart';
import 'package:chats/pages/otp/otp_page.dart';
import 'package:chats/pages/security_code/security_code_binding.dart';
import 'package:chats/pages/security_code/security_code_page.dart';
import 'package:chats/pages/sent_request_contact/sent_request_contact_binding.dart';
import 'package:chats/pages/sent_request_contact/sent_request_contact_page.dart';
import 'package:chats/pages/sign_in/sign_in_binding.dart';
import 'package:chats/pages/sign_in/sign_in_page.dart';
import 'package:chats/pages/sign_up/sign_up_binding.dart';
import 'package:chats/pages/sign_up/sign_up_page.dart';
import 'package:chats/pages/splash/splash_binding.dart';
import 'package:chats/pages/splash/splash_page.dart';
import 'package:chats/pages/update_password/update_password_binding.dart';
import 'package:chats/pages/update_password/update_password_page.dart';
import 'package:chats/pages/update_profile/update_profile_binding.dart';
import 'package:chats/pages/update_profile/update_profile_page.dart';
import 'package:chats/pages/upsert_instant_mess/upsert_instant_mess_binding.dart';
import 'package:chats/pages/upsert_instant_mess/upsert_instant_mess_page.dart';
import 'package:chats/pages/view_group_members/view_group_members_binding.dart';
import 'package:chats/pages/view_group_members/view_group_members_page.dart';
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
    GetPage(
      name: Routes.OPTIONS,
      page: () => OptionsPage(),
      binding: OptionsBinding(),
    ),
    GetPage(
      name: Routes.GROUP_MESSAGE,
      page: () => GroupMessagePage(),
      binding: GroupMessageBinding(),
    ),
    GetPage(
      name: Routes.GROUP_OPTION,
      page: () => GroupOptionPage(),
      binding: GroupOptionBinding(),
    ),
    GetPage(
      name: Routes.INSTANT_MESSAGE,
      page: () => InstantMessagePage(),
      binding: InstantMessageBinding(),
    ),
    GetPage(
      name: Routes.UPSERT_INSTANT_MESS,
      page: () => UpsertInstantMessPage(),
      binding: UpsertInstantMessBinding(),
    ),
    GetPage(
      name: Routes.VIEW_GROUP_MEMBERS,
      page: () => ViewGroupMembersPage(),
      binding: ViewGroupMembersBinding(),
    ),
    GetPage(
      name: Routes.MEDIA_FILES,
      page: () => MediaFilesPage(),
      binding: MediaFilesBinding(),
    ),
    GetPage(
      name: Routes.UPDATE_PROFILE,
      page: () => UpdateProfilePage(),
      binding: UpdateProfileBinding(),
    ),
    GetPage(
      name: Routes.UPDATE_PASSWORD,
      page: () => UpdatePasswordPage(),
      binding: UpdatePasswordBinding(),
    ),
    GetPage(
      name: Routes.SECURITY_CODE,
      page: () => SecurityCodePage(),
      binding: SecurityCodeBinding(),
    ),
    GetPage(
      name: Routes.ENTER_CODE_MUMBER,
      page: () => EnterCodeMumberPage(),
      binding: EnterCodeMumberBinding(),
    ),
  ];
}
