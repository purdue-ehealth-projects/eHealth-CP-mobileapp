import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

import 'main.dart';

Future<void> timezoneInit() async {
  tz.initializeTimeZones();
  final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}

Future<void> schedule24HoursAhead() async {
  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  final sharedPreferences = await SharedPreferences.getInstance();

  String? date = sharedPreferences.getString("date");
  String curDate =
      '${DateTime.now().year} ${DateTime.now().month} ${DateTime.now().day}';

  var tzDateTime = tz.TZDateTime(tz.local, now.year, now.month, now.day, 7, 0, 0, 0, 0);
  if (date == null || date == "" || date != curDate) {
    /// survey not complete; schedule for next hours until 8am next day
    print("hello\n");
    tzDateTime = tz.TZDateTime(tz.local, now.year, now.month, now.day, now.hour, 0, 0, 0, 0);
    int id = 0;
    for (int i = now.hour; i != 7; i = (i + 1) % 24) {
      tzDateTime = tzDateTime.add(const Duration(hours: 1));
      await scheduleHourlyNotification(id++, tzDateTime);
    }
  } else {
    /// survey completed; schedule for tomorrow
    tzDateTime.add(const Duration(days: 1));
    for (int i = 0; i <= 23; i++) {
      tzDateTime.add(const Duration(hours: 1));
      await scheduleHourlyNotification(i, tzDateTime);
    }
  }
}

Future<void> scheduleHourlyNotification(int id, tz.TZDateTime tzDateTime) async {
  print("scheduling $tzDateTime with id $id...\n");
  await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      'Daily Survey',
      'Please complete your survey',
      tzDateTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'survey id',
          'daily survey notification',
          channelDescription: 'please complete survey',
          priority: Priority.high,
          importance: Importance.high,
          fullScreenIntent: true,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
  );
}