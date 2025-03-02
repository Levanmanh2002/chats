import 'package:chats/resourese/dashboard/idashboard_repository.dart';
import 'package:get/get.dart';

class HtmlAppController extends GetxController {
  final IDashboardRepository dashboardRepository;

  HtmlAppController({required this.dashboardRepository});

  var htmlText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _systemSettingPusher();
  }

  void _systemSettingPusher() async {
    try {
      final response = await dashboardRepository.systemSettings();

      if (response.statusCode == 200) {
        htmlText.value = response.body['data']['page']['policy'];
      }
    } catch (e) {
      print(e);
    }
  }
}
