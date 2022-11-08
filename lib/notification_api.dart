import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

Future<void> timezoneInit() async {
  tz.initializeTimeZones();
  final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}

Future<void> scheduleNotifications() async {
  await timezoneInit();
  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  final sharedPreferences = await SharedPreferences.getInstance();

  final String? lastSurveyDate = sharedPreferences.getString("date");
  final String curDate =
      '${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}';

  // survey not complete; schedule for next hours until 8am next day
  if (lastSurveyDate == null ||
      lastSurveyDate == "" ||
      lastSurveyDate != curDate) {
    var scheduledNotifs =
        await AwesomeNotifications().listScheduledNotifications();
    // do nothing if notifications are already scheduled
    if (scheduledNotifs.isNotEmpty) {
      return;
    }

    // schedule every 15 minutes between 8 and 23
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
    for (int i = 0;
        i < 16 && 8 <= scheduleDateTime.hour && scheduleDateTime.hour <= 23;
        i++) {
      for (int j = 0; j < 4; j++) {
        await _createNotif(id, scheduleDateTime);
        id++;
        scheduleDateTime = scheduleDateTime.add(const Duration(minutes: 15));
      }
    }
  } else {
    // survey completed; clear all notifs; schedule for tomorrow starting at 9
    await AwesomeNotifications().cancelAll();
    var scheduleDateTime = tz.TZDateTime(
        tz.local, now.year, now.month, now.day + 1, 8, 0, 0, 0, 0);
    int id = 1;
    for (int i = 0; i < 16; i++) {
      for (int j = 0; j < 4; j++) {
        await _createNotif(id, scheduleDateTime);
        id++;
        scheduleDateTime = scheduleDateTime.add(const Duration(minutes: 15));
      }
    }
  }
}

Future<void> _createNotif(int id, DateTime dt) async {
  String localTimeZone =
      await AwesomeNotifications().getLocalTimeZoneIdentifier();

  await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'basic_channel',
        title: 'Survey Reminder',
        body: 'Please complete your survey today.',
        notificationLayout: NotificationLayout.BigPicture,
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
