import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'database.dart';
import 'graph_survey.dart';
import 'login_page.dart';
import 'notification_api.dart';
import 'survey_page.dart';

/// Main Homepage that gets called in main.
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  /// Global navigator key
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  State<HomePage> createState() => _HomePageState();
}

/// Homepage state
class _HomePageState extends State<HomePage> {
  /// Original Future reference to prevent infinite looping.
  late Future data;

  @override
  void initState() {
    super.initState();
    data = loadLocalData();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        // This is just a basic example. For real apps, you must show some
        // friendly dialog box before call the request method.
        // This is very important to not harm the user experience
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: receiveMethod,
    );
  }

  String _username = '';
  bool _loading = true;
  bool _signin = false;
  bool _didSurvey = false;
  final List<SurveyScores> _graphSS = [];
  String _needs = '';
  int _scoreToday = -1;

  /// Page push after user clicks on notification
  static Future<void> receiveMethod(ReceivedAction ra) async {
    Navigator.push(
        HomePage.navigatorKey.currentState!.context,
        MaterialPageRoute(
          builder: (_) => const HomePage(),
        ));
  }

  /// Load local date from storage to app memory.
  Future<void> loadLocalData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? username = prefs.getString("username");
    final String? password = prefs.getString("password");

    if (username == null || password == null) {
      _signin = false;
    } else {
      // false if ret is not 0
      _signin = (await loginUser(username, password) == 0);
    }

    if (_signin) {
      _username = username!;

      final String? lastSurveyDate = prefs.getString("lastSurveyDate");
      final String curDate =
          '${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}';

      if (lastSurveyDate == curDate) {
        _didSurvey = true;
        _scoreToday = prefs.getInt("scoreToday")!;
        _needs = prefs.getString("needs")!;

        final List<String>? scores = prefs.getStringList("scores");
        final List<String>? dates = prefs.getStringList("dates");

        if (scores != null &&
            scores.isNotEmpty &&
            dates != null &&
            dates.isNotEmpty) {
          for (int i = dates.length < 5 ? 0 : dates.length - 5;
              i < dates.length;
              i++) {
            _graphSS.add(SurveyScores(dates[i], int.parse(scores[i])));
          }
        }
      }
    } else {
      // clear all local storage
      await prefs.clear();
    }
    // Set state here to redraw app
    setState(() {
      _loading = false;
    });
    // Schedule notifications
    // This can be done in background and doesn't need to be completed during
    // loading screen.
    await scheduleNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final Scaffold loadingScaffold = Scaffold(
      backgroundColor: const Color(0xff0b3954),
      body: Padding(
        padding:
            EdgeInsets.symmetric(vertical: size.height / 3, horizontal: 125),
        child: const LoadingIndicator(
            indicatorType: Indicator.circleStrokeSpin,
            colors: [Colors.greenAccent],
            backgroundColor: Colors.transparent,
            pathBackgroundColor: Colors.transparent),
      ),
    );

    return FutureBuilder(
      future: data,
      builder: (context, snapshot) {
        // scoreToday == -1
        return _loading == true
            ? loadingScaffold
            : (_signin == true
                ? const LoginPage()
                : (_didSurvey == false
                    ? SurveyWelcomePage(name: _username.toString())
                    : GraphSurvey(
                        gSS: _graphSS,
                        scoreToday: _scoreToday,
                        name: _username,
                        needs: _needs,
                      )));
      },
    );
  }
}

/// Survey score model.
class SurveyScores {
  SurveyScores(this.date, this.score);
  final String date;
  final int score;
}
