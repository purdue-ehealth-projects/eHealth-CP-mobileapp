import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

/// Initiate timezone in tz
Future<void> timezoneInit() async {
  tz.initializeTimeZones();
  final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}

/// Schedule notificaitons accordingly.
Future<void> scheduleNotifications() async {
  await timezoneInit();
  final prefs = await SharedPreferences.getInstance();
  final String? lastSurveyDate = prefs.getString("lastSurveyDate");
  // reload here is necessary to get the updated scheduledDate value
  await prefs.reload();
  final String? scheduledDate = prefs.getString("scheduledDate");
  final String curDate =
      '${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}';

  if (scheduledDate == null || scheduledDate != curDate) {
    await prefs.setString("scheduledDate", curDate);
    await AwesomeNotifications().cancelAll();
    await _scheduleToday();
    await _scheduleNext7days();
  }

  if (lastSurveyDate == curDate) {
    await _cancelToday();
  }
}

Future<void> _cancelToday() async {
  for (int id = 1; id < 61; id++) {
    await AwesomeNotifications().cancel(id);
  }
}

/// Schedule notifications today every 15 minutes between 8 and 23.
/// Each day contains at most 60 notifications.
Future<void> _scheduleToday() async {
  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  tz.TZDateTime scheduleDateTime;
  int scheduleHour = -1;
  if (now.hour > 8) {
    scheduleHour = now.hour;
  } else {
    scheduleHour = 8;
  }

  scheduleDateTime = tz.TZDateTime(
      tz.local, now.year, now.month, now.day, scheduleHour, 0, 0, 0, 0);
  int id = 1;
  for (int hour = 0;
      hour < 15 && 8 <= scheduleDateTime.hour && scheduleDateTime.hour <= 22;
      hour++) {
    for (int quarter = 0; quarter < 4; quarter++) {
      await _createNotif(id, scheduleDateTime);
      id++;
      scheduleDateTime = scheduleDateTime.add(const Duration(minutes: 15));
    }
  }
}

/// Schedule notification for the next 7 days - every 15 minutes between 8 and
/// 23 every day.
Future<void> _scheduleNext7days() async {
  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  int scheduleDay = now.day + 1;
  // Each day has at most 15 * 4 = 60 notifs, so notifs the next day starts at
  // 61
  int id = 61;
  for (int day = 0; day < 7; day++) {
    var scheduleDateTime = tz.TZDateTime(
        tz.local, now.year, now.month, scheduleDay, 8, 0, 0, 0, 0);
    for (int hour = 0; hour < 15; hour++) {
      for (int quarter = 0; quarter < 4; quarter++) {
        await _createNotif(id, scheduleDateTime);
        id++;
        scheduleDateTime = scheduleDateTime.add(const Duration(minutes: 15));
      }
    }
    scheduleDay++;
  }
}

Future<void> _createNotif(int id, DateTime dt) async {
  final String localTimeZone =
      await AwesomeNotifications().getLocalTimeZoneIdentifier();

  await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'basic_channel',
        title: 'Survey Reminder',
        body: 'Please complete your survey today.',
        notificationLayout: NotificationLayout.BigPicture,
        bigPicture: 'asset://assets/ems_health_icon3_small.png',
        largeIcon: 'asset://assets/ems_health_icon3_small.png',
        fullScreenIntent: true,
        wakeUpScreen: true,
        category: NotificationCategory.Reminder,
      ),
      schedule: NotificationCalendar(
        year: dt.year,
        month: dt.month,
        day: dt.day,
        hour: dt.hour,
        minute: dt.minute,
        allowWhileIdle: true,
        // battery conscious
        preciseAlarm: false,
        timeZone: localTimeZone,
      ));
}
