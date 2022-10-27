import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:emshealth/notification_api.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:emshealth/database.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// Main imports environmental variables, connect to MongoDB, and calls
/// MyApp.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  await MongoDB.connect();

  await AwesomeNotifications().initialize(
      null,  //icon is null right now
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
      debug: true
  );

  AwesomeNotifications().setListeners(
    onActionReceivedMethod: receiveMethod,
  );

  runApp(const MyApp());
}

Future<void> receiveMethod(ReceivedAction ra) async {
  Navigator.push(navigatorKey.currentState!.context, MaterialPageRoute(
    builder: (_) => const HomePage(),
  ));
}

/// Main app screen that is called first by default. Redirects to homepage.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
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
