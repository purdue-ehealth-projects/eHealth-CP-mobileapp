import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:emshealth/awesome_notification_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'home_page.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:emshealth/database.dart';
import 'notification_api.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

/// Main imports environmental variables, connect to MongoDB, and calls
/// MyApp.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  await MongoDB.connect();

  // Initialize local notification plugin. (TODO: Configure for iOS)
  /*const AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings('app_icon');
  const InitializationSettings initializationSettings = InitializationSettings(
    android: androidInitializationSettings,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse nr) {
      Navigator.push(navigatorKey.currentState!.context, MaterialPageRoute(
        builder: (_) => HomePage(),
      ));
    }
  );
  flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()?.requestPermission();

  // Initialize time zone.
  await timezoneInit();

  // Schedule first day.
  //await schedule24HoursAhead();
  await scheduleEveryMinNotification();*/

  /// using awesome_notification package.
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });
  
  AwesomeNotifications().initialize(
    // set the icon to null if you want to use the default app icon
      null,
      [
        NotificationChannel(
            channelGroupKey: 'basic_tests',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: const Color(0xFF9D50DD),
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

  await timezoneInit();
  await schedule24HoursAheadAN();

  runApp(const MyApp());
}

Future<void> receiveMethod(ReceivedAction ra) async {
  Navigator.push(navigatorKey.currentState!.context, MaterialPageRoute(
    builder: (_) => HomePage(),
  ));
}

/// Main app screen that is called first by default. Redirects to homepage.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  initState() {
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: receiveMethod,
    );
  }

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
