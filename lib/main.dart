import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

import 'home_page.dart';
import 'notification_api.dart';
import 'notification_week_and_time.dart';

void scheduleHourly() {
  print("Hello");
  DateTime now = DateTime.now();
  NotificationWeekAndTime? nw = NotificationWeekAndTime(dayOfTheWeek: now.day, timeOfDay: TimeOfDay.now());
  createHourlyReminder(nw);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
  final int helloAlarmID = 0;
  await AndroidAlarmManager.initialize();
  runApp(MyApp());
  await AndroidAlarmManager.periodic(
    const Duration(hours: 24), //Do the same every 24 hours
    helloAlarmID, //Different ID for each alarm
    scheduleHourly,
    wakeup: true, //the device will be woken up when the alarm fires
    startAt: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 8, 0), //Start whit the specific time 8:00 am
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
        accentColor: Colors.tealAccent,
      ),
      title: 'EMS Health',
      home: HomePage(),
    );
  }
}
