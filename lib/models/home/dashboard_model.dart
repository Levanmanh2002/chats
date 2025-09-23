class DashboardOverview {
  final bool success;
  final String message;
  final DashboardData data;

  DashboardOverview({
    required this.success,
    required this.message,
    required this.data,
  });

  factory DashboardOverview.fromJson(Map<String, dynamic> json) {
    return DashboardOverview(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: DashboardData.fromJson(json['data'] ?? {}),
    );
  }
}

class DashboardData {
  final int totalNotes;
  final int completedNotes;
  final int inprogressNotes;
  final int overdueNotes;
  final int newNotes;
  final int canceledNotes;
  final int dueTodayNotes;
  final int dueSoonNotes;
  final String todayDate;
  final String greeting;

  DashboardData({
    required this.totalNotes,
    required this.completedNotes,
    required this.inprogressNotes,
    required this.overdueNotes,
    required this.newNotes,
    required this.canceledNotes,
    required this.dueTodayNotes,
    required this.dueSoonNotes,
    required this.todayDate,
    required this.greeting,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      totalNotes: json['total_notes'] ?? 0,
      completedNotes: json['completed_notes'] ?? 0,
      inprogressNotes: json['inprogress_notes'] ?? 0,
      overdueNotes: json['overdue_notes'] ?? 0,
      newNotes: json['new_notes'] ?? 0,
      canceledNotes: json['canceled_notes'] ?? 0,
      dueTodayNotes: json['due_today_notes'] ?? 0,
      dueSoonNotes: json['due_soon_notes'] ?? 0,
      todayDate: json['today_date'] ?? '',
      greeting: json['greeting'] ?? '',
    );
  }
}

class WorkStatusChart {
  final bool success;
  final String message;
  final ChartData data;

  WorkStatusChart({
    required this.success,
    required this.message,
    required this.data,
  });

  factory WorkStatusChart.fromJson(Map<String, dynamic> json) {
    return WorkStatusChart(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: ChartData.fromJson(json['data'] ?? {}),
    );
  }
}

class ChartData {
  final List<ChartItem> chartData;
  final int totalTasks;

  ChartData({
    required this.chartData,
    required this.totalTasks,
  });

  factory ChartData.fromJson(Map<String, dynamic> json) {
    return ChartData(
      chartData: (json['chart_data'] as List?)?.map((item) => ChartItem.fromJson(item)).toList() ?? [],
      totalTasks: json['total_tasks'] ?? 0,
    );
  }
}

class ChartItem {
  final String label;
  final int value;
  final String color;
  final double percentage;

  ChartItem({
    required this.label,
    required this.value,
    required this.color,
    required this.percentage,
  });

  factory ChartItem.fromJson(Map<String, dynamic> json) {
    return ChartItem(
      label: json['label'] ?? '',
      value: json['value'] ?? 0,
      color: json['color'] ?? '#000000',
      percentage: (json['percentage'] ?? 0).toDouble(),
    );
  }
}

class CalendarResponse {
  final bool success;
  final String message;
  final CalendarData data;

  CalendarResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CalendarResponse.fromJson(Map<String, dynamic> json) {
    return CalendarResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: CalendarData.fromJson(json['data'] ?? {}),
    );
  }
}

class CalendarData {
  final List<CalendarDay> calendarDays;
  final String currentMonth;
  final String monthName;
  final String year;
  final String month;
  final int totalDeadlinesThisMonth;
  final int totalRemindersThisMonth;

  CalendarData({
    required this.calendarDays,
    required this.currentMonth,
    required this.monthName,
    required this.year,
    required this.month,
    required this.totalDeadlinesThisMonth,
    required this.totalRemindersThisMonth,
  });

  factory CalendarData.fromJson(Map<String, dynamic> json) {
    return CalendarData(
      calendarDays: (json['calendar_days'] as List?)?.map((item) => CalendarDay.fromJson(item)).toList() ?? [],
      currentMonth: json['current_month'] ?? '',
      monthName: json['month_name'] ?? '',
      year: json['year'] ?? '',
      month: json['month'] ?? '',
      totalDeadlinesThisMonth: json['total_deadlines_this_month'] ?? 0,
      totalRemindersThisMonth: json['total_reminders_this_month'] ?? 0,
    );
  }
}

class CalendarDay {
  final String date;
  final int day;
  final bool isToday;
  final bool hasTasks;
  final int taskCount;
  final int deadlineCount;
  final int reminderCount;
  final List<CalendarTask> tasks;

  CalendarDay({
    required this.date,
    required this.day,
    required this.isToday,
    required this.hasTasks,
    required this.taskCount,
    required this.deadlineCount,
    required this.reminderCount,
    required this.tasks,
  });

  factory CalendarDay.fromJson(Map<String, dynamic> json) {
    return CalendarDay(
      date: json['date'] ?? '',
      day: json['day'] ?? 0,
      isToday: json['is_today'] ?? false,
      hasTasks: json['has_tasks'] ?? false,
      taskCount: json['task_count'] ?? 0,
      deadlineCount: json['deadline_count'] ?? 0,
      reminderCount: json['reminder_count'] ?? 0,
      tasks: (json['tasks'] as List?)?.map((item) => CalendarTask.fromJson(item)).toList() ?? [],
    );
  }
}

class CalendarTask {
  final int id;
  final String title;
  final String priority;
  final String status;
  final bool isCompleted;
  final bool isOverdue;
  final bool isDeadline;
  final bool isReminder;
  final String? deadlineTime;
  final String? reminderTime;
  final String type;

  CalendarTask({
    required this.id,
    required this.title,
    required this.priority,
    required this.status,
    required this.isCompleted,
    required this.isOverdue,
    required this.isDeadline,
    required this.isReminder,
    this.deadlineTime,
    this.reminderTime,
    required this.type,
  });

  factory CalendarTask.fromJson(Map<String, dynamic> json) {
    return CalendarTask(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      priority: json['priority'] ?? '',
      status: json['status'] ?? '',
      isCompleted: json['is_completed'] ?? false,
      isOverdue: json['is_overdue'] ?? false,
      isDeadline: json['is_deadline'] ?? false,
      isReminder: json['is_reminder'] ?? false,
      deadlineTime: json['deadline_time'],
      reminderTime: json['reminder_time'],
      type: json['type'] ?? '',
    );
  }
}
