import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:emshealth/database.dart';

/// Main imports environmental variables, connect to MongoDB, set up
/// Notifications, and runs MyApp.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  await MongoDB.connect();

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
  runApp(const MyApp());
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