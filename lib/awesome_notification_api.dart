import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

Future<void> timezoneInit() async {
  tz.initializeTimeZones();
  final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}

Future<void> schedule24HoursAheadAN() async {
  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  final sharedPreferences = await SharedPreferences.getInstance();

  String? date = sharedPreferences.getString("date");
  String curDate =
      '${DateTime.now().year} ${DateTime.now().month} ${DateTime.now().day}';

  if (date == null || date == "" || date != curDate) {
    /// survey not complete; schedule for next hours until 8am next day
    var tzDateTime = tz.TZDateTime(tz.local, now.year, now.month, now.day, now.hour, 0, 0, 0, 0);
    int id = 0;
    for (int i = now.hour; i != 8; i = (i + 1) % 24) {
      tzDateTime = tzDateTime.add(const Duration(hours: 1));
      await scheduleHourlyAN(id++, tzDateTime);
    }
  } else {
    /// survey completed; schedule for tomorrow
    var tzDateTime = tz.TZDateTime(tz.local, now.year, now.month, now.day + 1, 7, 0, 0, 0, 0);
    for (int i = 0; i <= 23; i++) {
      tzDateTime.add(const Duration(hours: 1));
      await scheduleHourlyAN(i, tzDateTime);
    }
  }

}

Future<void> scheduleHourlyAN(int id, DateTime dt) async {
  String localTimeZone = await AwesomeNotifications().getLocalTimeZoneIdentifier();

  await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: id,
          channelKey: 'basic_channel',
          title: 'Survey Reminder',
          body:'Please complete your survey today.',
          notificationLayout: NotificationLayout.BigPicture,
          largeIcon: 'asset://assets/ems_health_icon3_small.png',
          fullScreenIntent: true,
          wakeUpScreen: true,
      ),

      schedule: NotificationCalendar(
        year: dt.year,
        month: dt.month,
        day: dt.day,
        hour: dt.hour,
        minute: dt.minute,
        allowWhileIdle: true,
        preciseAlarm: true,
        timeZone: localTimeZone,
      ));
}