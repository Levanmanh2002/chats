import 'package:chats/pages/features/features_controller.dart';
import 'package:get/get.dart';

class FeaturesBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FeaturesController());
  }
}
