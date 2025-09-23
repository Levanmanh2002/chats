import 'package:chats/models/home/dashboard_model.dart';
import 'package:chats/resourese/home/ihome_repository.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final IHomeRepository homeRepository;

  HomeController({required this.homeRepository});

  final Rx<DashboardData?> dashboardData = Rx<DashboardData?>(null);
  final Rx<ChartData?> chartData = Rx<ChartData?>(null);
  final Rx<CalendarData?> calendarData = Rx<CalendarData?>(null);

  final RxBool isLoading = false.obs;
  final RxBool isLoadingChart = false.obs;
  final RxBool isLoadingCalendar = false.obs;

  final RxInt currentMonth = DateTime.now().month.obs;
  final RxInt currentYear = DateTime.now().year.obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    await Future.wait([
      getDashboardOverview(),
      getWorkStatusChart(),
      getCalendarData(),
    ]);
  }

  Future<void> getDashboardOverview() async {
    try {
      isLoading.value = true;
      final response = await homeRepository.getDashboardOverview();

      if (response.statusCode == 200 && response.body != null) {
        final overview = DashboardOverview.fromJson(response.body);
        if (overview.success) {
          dashboardData.value = overview.data;
        } else {
          Get.snackbar('Lỗi', overview.message);
        }
      } else {
        Get.snackbar('Lỗi', 'Không thể tải dữ liệu dashboard');
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Đã xảy ra lỗi: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getWorkStatusChart() async {
    try {
      isLoadingChart.value = true;
      final response = await homeRepository.getWorkStatusChart();

      if (response.statusCode == 200 && response.body != null) {
        final chart = WorkStatusChart.fromJson(response.body);
        if (chart.success) {
          chartData.value = chart.data;
        } else {
          Get.snackbar('Lỗi', chart.message);
        }
      } else {
        Get.snackbar('Lỗi', 'Không thể tải dữ liệu biểu đồ');
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Đã xảy ra lỗi: $e');
    } finally {
      isLoadingChart.value = false;
    }
  }

  Future<void> getCalendarData() async {
    try {
      isLoadingCalendar.value = true;
      final response = await homeRepository.getCalendarData(
        month: currentMonth.value,
        year: currentYear.value,
      );

      if (response.statusCode == 200 && response.body != null) {
        final calendar = CalendarResponse.fromJson(response.body);
        if (calendar.success) {
          calendarData.value = calendar.data;
        } else {
          Get.snackbar('Lỗi', calendar.message);
        }
      } else {
        Get.snackbar('Lỗi', 'Không thể tải dữ liệu lịch');
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Đã xảy ra lỗi: $e');
    } finally {
      isLoadingCalendar.value = false;
    }
  }

  void changeMonth(int direction) {
    if (direction > 0) {
      if (currentMonth.value == 12) {
        currentMonth.value = 1;
        currentYear.value++;
      } else {
        currentMonth.value++;
      }
    } else {
      if (currentMonth.value == 1) {
        currentMonth.value = 12;
        currentYear.value--;
      } else {
        currentMonth.value--;
      }
    }
    getCalendarData();
  }

  Future<void> refreshData() async {
    await loadDashboardData();
  }
}
