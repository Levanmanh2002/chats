import 'package:chats/helper/notification_helper.dart';
import 'package:chats/resourese/service/app_service.dart';
import 'package:chats/resourese/service/localization_service.dart';
import 'package:chats/resourese/service/pusher_service.dart';
import 'package:chats/routes/pages.dart';
import 'package:chats/theme/app_theme_util.dart';
import 'package:chats/theme/base_theme_data.dart';
import 'package:chats/utils/app_constants.dart';
import 'package:chats/utils/app_enums.dart';
import 'package:chats/utils/local_storage.dart';
import 'package:chats/widget/reponsive/size_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

AppThemeUtil themeUtil = AppThemeUtil();
BaseThemeData get appTheme => themeUtil.getAppTheme();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await LocalStorage.init();
  await AppService.initAppService();
  await PusherService.initPusher();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  try {
    await NotificationHelper.initialize();
    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
  } catch (_) {}

  runApp(LayoutBuilder(builder: (context, constraints) {
    SizeConfig.instance.init(constraints: constraints, screenHeight: 812, screenWidth: 375);

    return const MyApp();
  }));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    themeUtil.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      locale: LocalizationService.language.locale,
      supportedLocales: LocalizationService.supportedLanguage.map((e) => e.locale).toList(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      fallbackLocale: LocalizationService.fallbackLanguage.locale,
      translations: LocalizationService(),
      theme: ThemeData(
        primarySwatch: MaterialColor(
          appTheme.appColor.value,
          <int, Color>{
            50: appTheme.appColor,
            100: appTheme.appColor,
            200: appTheme.appColor,
            300: appTheme.appColor,
            400: appTheme.appColor,
            500: appTheme.appColor,
            600: appTheme.appColor,
            700: appTheme.appColor,
            800: appTheme.appColor,
            900: appTheme.appColor,
          },
        ),
        scaffoldBackgroundColor: appTheme.whiteColor,
      ),
      initialRoute: Routes.SPLASH,
      getPages: AppPages.pages,
      builder: EasyLoading.init(),
    );
  }
}

/// cập nhật lại dữ liệu danh sách bạn bè đã kết bạn để bắt sự kiện vô màn chi tiết bạn bè