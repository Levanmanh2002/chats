import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static const String appName = 'HappyHouse';

  static const int minNameLength = 2;
  static const int minAddressLength = 12;
  static const int maxNameLength = 255;
  static const int timeOtp = 120;

  static const String fontFamilyBold = 'SemiBold';
  static const String fontFamilyRegular = 'Regular';

  static String baseUrl = dotenv.get('BASE_URL');

  static String userType = 'client';

  static const String notificationChannelId = 'PREEPS-HAPPY-HOUSES-DRIVER-NOTIFICATION-CHANNEL-ID';

  static const String signInUri = '/api/v1/auth/login';
  static const String signUpUri = '/api/v1/auth/register';
  static const String forgotPasswordUri = '/api/v1/auth/forgot-password';
  static const String updatePasswordUri = '/api/v1/auth/update-password-by-otp';
  static const String requestOtpUri = '/api/v1/auth/request-otp';
  static const String verifyOtpUri = '/api/v1/auth/verify-otp';
  static const String profileUri = '/api/v1/account/profile';
  static const String logoutUri = '/api/v1/account/logout';
  static const String updateAvatarUri = '/api/v1/account/update-avatar';

  static const String searchContactPhoneUri = '/api/v1/contact/find-user?search=';
  static const String findAccountUri = '/api/v1/account/find';
}
