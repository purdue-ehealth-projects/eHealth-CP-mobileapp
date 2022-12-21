import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'dart:ui';
import 'dart:async';

import 'home_page.dart';
import 'database.dart';
import 'notification_api.dart';

/// Main imports environmental variables, connect to MongoDB, set up
/// Notifications, and runs MyApp.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  await initializeBackgroundSerive();
  AwesomeNotifications().initialize(
      null, //icon is null right now
      [
        NotificationChannel(
          channelGroupKey: 'basic_tests',
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: Colors.blueAccent,
          ledColor: Colors.white,
          importance: NotificationImportance.High,
        ),
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'basic_tests',
            channelGroupName: 'Basic test group')
      ],
      debug: true);
  // we need to connect in main as homepage won't initalize again on app restart
  await MongoDB.connect();
  runApp(const MyApp());
}

Future<void> initializeBackgroundSerive() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: false,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onBackground: onIosBackground,
    ),
  );
  service.startService();
}

/// To ensure this is executed
/// run app from xcode, then from xcode menu, select Simulate Background Fetch
///
/// Runs every 15 minutes (by iOS) in the background for 15-30 seconds
@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  await scheduleNotifications();
  return true;
}

@pragma('vm:entry-point')
Future<void> onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }
  service.on('stopService').listen((event) {
    service.stopSelf();
  });
  // Try to schedule notifications every 2 hours in the background
  Timer.periodic(const Duration(hours: 2), (timer) async {
    await scheduleNotifications();
  });
}

/// Main app screen that is called first by default. Redirects to homepage.
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
