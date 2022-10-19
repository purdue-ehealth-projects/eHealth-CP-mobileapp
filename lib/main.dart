import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

import 'home_page.dart';
import 'notification_api.dart';
import 'notification_week_and_time.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:emshealth/database.dart';

void scheduleHourly() {
  cancelScheduledNotifications();
  DateTime dt = DateTime.now();
  NotificationWeekAndTime? nw =
      NotificationWeekAndTime(dayOfTheWeek: dt.day, timeOfDay: TimeOfDay.now());
  createHourlyReminder(nw);
  nw = NotificationWeekAndTime(
      dayOfTheWeek: dt.day + 1,
      timeOfDay: TimeOfDay.fromDateTime(
          DateTime(dt.year, dt.month, dt.day + 1, 8, 0, 0, 0, 0)));
  createDailyReminder(nw);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  await MongoDB.connect();
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'hourly_channel',
        channelName: 'Scheduled Notifications',
        defaultColor: Colors.teal,
        locked: false,
        importance: NotificationImportance.High,
      ),
      NotificationChannel(
        channelKey: 'daily_channel',
        channelName: 'Scheduled Notifications',
        defaultColor: Colors.teal,
        locked: false,
        importance: NotificationImportance.High,
      ),
    ],
  );

  await AndroidAlarmManager.initialize();
  runApp(const MyApp());
  const int helloAlarmID = 0;
  await AndroidAlarmManager.periodic(
    const Duration(hours: 24), //Do the same every 24 hours
    helloAlarmID, //Different ID for each alarm
    scheduleHourly,
    exact: true,
    wakeup: true, //the device will be woken up when the alarm fires
    startAt: DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, 8, 0), //Start whit the specific time 8:00 am
    allowWhileIdle: true,
    rescheduleOnReboot: true, //Work after reboot
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.teal,
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: Colors.tealAccent),
      ),
      title: 'EMS Health',
      home: const HomePage(),
    );
  }
}
