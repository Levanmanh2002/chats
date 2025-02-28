import 'package:chats/utils/local_storage.dart';
import 'package:chats/utils/shared_key.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static const String appName = 'Chat - Nhà Táo';

  static const int minNameLength = 2;
  static const int minAddressLength = 12;
  static const int maxNameLength = 255;
  static const int timeOtp = 120;
  static const int timeTrackingOnline = 1;

  static const String fontFamilyBold = 'SemiBold';
  static const String fontFamilyRegular = 'Regular';

  static String baseUrl = dotenv.get('BASE_URL');
  static String get pusherApiKey => LocalStorage.getString(SharedKey.PUSHER_API_KEY);
  static String pusherApiCluster = dotenv.get('PUSHER_API_CLUSTER');
  static String pusherChannel = dotenv.get('PUSHER_CHANNEL');
  static String userType = 'client';

  static const String notificationChannelId = 'CHATS-DRIVER-NOTIFICATION-CHANNEL-ID';
  static const String rejectCallChannelId = 'CHATS-REJECT-CALL-CHANNEL-ID';

  static const String signInUri = '/api/v1/auth/login';
  static const String signUpUri = '/api/v1/auth/register';
  static const String forgotPasswordUri = '/api/v1/auth/forgot-password';
  static const String updatePasswordUri = '/api/v1/auth/update-password-by-otp';
  static const String requestOtpUri = '/api/v1/auth/request-otp';
  static const String verifyOtpUri = '/api/v1/auth/verify-otp';
  static const String profileUri = '/api/v1/account/profile';
  static const String logoutUri = '/api/v1/account/logout';
  static const String updateAvatarUri = '/api/v1/account/update-avatar';
  static const String updateProfileUri = '/api/v1/account/update-profile';
  static const String updateNewPasswordUri = '/api/v1/account/update-password';
  static const String deleteAccountUri = '/api/v1/account/remove-account';
  static const String updateFcmTokenUri = '/api/v1/account/update-fcm-token';
  static const String systemSettingsUri = '/api/v1/system/settings';
  static const String trackingTimeOnlineUri = '/api/v1/account/tracking-time-online';

  static const String searchContactPhoneUri = '/api/v1/contact/find-user';
  static const String findAccountUri = '/api/v1/account/find';
  static const String addFriendUri = '/api/v1/contact/send-friend-request';
  static const String removeFriendUri = '/api/v1/contact/remove-friend-request';
  static const String getReceivedRequestContactUri = '/api/v1/contact/my-friend-requested';
  static const String getSentRequestContactUri = '/api/v1/contact/friend-requesteds';
  static const String cancelFriendRequestUri = '/api/v1/contact/cancel-friend-request';
  static const String acceptFriendRequestUri = '/api/v1/contact/accept-friend-request';
  static const String contactAcceptedUri = '/api/v1/contact/friends';
  static const String unfriendUri = '/api/v1/contact/unfriend';
  static String getIdChatByUser(int userId) => '/api/v1/message/$userId/get-chat-id-by-user';
  static const String sendMessageUri = '/api/v1/message/send-message-to-user';
  static String messageList(int chatId, {int page = 1, int limit = 10, String search = ''}) =>
      '/api/v1/message/$chatId/conversion?page=$page&size=$limit&search=$search';
  static const String chatListAllUri = '/api/v1/message/conversions';
  static String heartMessage(int messageId) => '/api/v1/message/$messageId/like';
  static String revokeMessage(int messageId) => '/api/v1/message/$messageId/rollback';
  static const String createGroupUri = '/api/v1/message/create-group';
  static const String sendMessageGroupUri = '/api/v1/message/send-message-to-group';
  static const String renameGroupUri = '/api/v1/message/rename-group';
  static const String addInstantMessUri = '/api/v1/message/instant/add';
  static const String getQuickMessageUri = '/api/v1/message/instant/list?chat_id=';
  static const String updateInstantMessUri = '/api/v1/message/instant/edit';
  static const String deleteInstantMessUri = '/api/v1/message/instant/delete';
  static const String addUserToGroupUri = '/api/v1/message/add-user-to-group';
  static const String removeUserFromGroupUri = '/api/v1/message/remove-user-from-group';
  static const String transferOwnershipUri = '/api/v1/message/left-group';
  static String getImageFileByChatId(int chatId, String type, {int page = 1, int limit = 10}) =>
      '/api/v1/message/$chatId/files?type=$type&page=$page&size=$limit';
  static String deleteChat(int chatId) => '/api/v1/message/$chatId/delete';
  static const String endableSecurityUri = '/api/v1/account/endable-security';
  static const String disableSecurityUri = '/api/v1/account/disable-security';
  static const String changeSecurityUri = '/api/v1/account/change-security';
  static const String syncContactsUri = '/api/v1/contact/sync-contacts';
  static const String getSyncContactsUri = '/api/v1/contact/list-contacts';
  static const String getTickersUri = '/api/v1/tickers/list?page=1&size=100';

  static const String generateTokentUri = '/api/v1/call/gen-token';
  static const String initCallUri = '/api/v1/call/init-call';
  static const String rejectCallUri = '/api/v1/call/reject-call';
  static const String joinCallUri = '/api/v1/call/join-call';
  static const String endCallUri = '/api/v1/call/end-call';
}
