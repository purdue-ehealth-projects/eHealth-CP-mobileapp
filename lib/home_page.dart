import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:emshealth/completion_page.dart';
import 'package:emshealth/database.dart';
import 'package:emshealth/notification_api.dart';
import 'package:emshealth/survey_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'graph_survey.dart';
import 'login_page.dart';
import 'notification_week_and_time.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  bool goBack = false;
  String? username = '';
  bool signin = false;
  bool didSurvey = false;
  List<SurveyScores> graphSS = [];
  int scoreToday = -1;

  @override
  void initState() {
    super.initState();

    //get local data
    //DateTime now = DateTime.now();

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Allow Notifications'),
            content: const Text('Our app would like to send you notifications'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Don\'t Allow',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
              ),
              TextButton(
                  onPressed: () => AwesomeNotifications()
                      .requestPermissionToSendNotifications()
                      .then((_) => Navigator.pop(context)),
                  child: const Text(
                    'Allow',
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ))
            ],
          ),
        );
      }
    });

    AwesomeNotifications().actionStream.listen((notification) async {
      await loadLocalData();
      if (didSurvey) {
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => GraphSurvey(graphSS, scoreToday),
          ),
          (route) => route.isFirst,
        );
      } else if (signin) {
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => SurveyWelcomePage(username: username.toString()),
          ),
          (route) => route.isFirst,
        );
      } else {
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const LoginPage(),
          ),
          (route) => route.isFirst,
        );
      }
    });
  }

  Future<void> loadLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String curDate =
        '${DateTime.now().year} ${DateTime.now().month} ${DateTime.now().day}';

    username = prefs.getString("username");
    String? password = prefs.getString("password");
    String? date = prefs.getString("date");

    if (username != null &&
        username != "" &&
        password != null &&
        password != "") {
      signin = true;
      if (date == curDate) {
        didSurvey = true;
        scoreToday = prefs.getInt("scoreToday")!;

        List<String>? scores = prefs.getStringList("scores");
        List<String>? dates = prefs.getStringList("dates");

        if (scores != null && dates != null) {
          for (int i = 0; i < scores.length; i++) {
            graphSS.add(SurveyScores(dates[i], int.parse(scores[i])));
          }
        }
      }
    }
  }

  @override
  void dispose() {
    AwesomeNotifications().actionSink.close();
    AwesomeNotifications().createdSink.close();
    AwesomeNotifications().displayedSink.close();
    MongoDB.cleanupDatabase();
    super.dispose();
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (didSurvey) {
      cancelScheduledNotifications();
      DateTime now = DateTime.now();
      NotificationWeekAndTime? nw = NotificationWeekAndTime(
          dayOfTheWeek: now.day + 1,
          timeOfDay: TimeOfDay.fromDateTime(
              DateTime(now.year, now.month, now.day + 1, 8, 0, 0, 0, 0)));
      createDailyReminder(nw);
    }

    return FutureBuilder(
      future: loadLocalData(),
      builder: (context, snapshot) {
        //Size size = MediaQuery.of(context).size;
        return scoreToday == -1
            ? (signin
                ? SurveyWelcomePage(username: username.toString())
                : const LoginPage())
            : GraphSurvey(graphSS, scoreToday);
      },
    );
  }

  @override
  // implement wantKeepAlive
  bool get wantKeepAlive => true;
}

loginFailedAlert(BuildContext context) {
  // set up the button
  Widget okButton = TextButton(
    child: const Text("OK"),
    onPressed: () => Navigator.pop(context, 'Cancel'),
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Login Failed"),
    content: const Text("Wrong username or password. Please try again."),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

registerFailedAlert(BuildContext context) {
  // set up the button
  Widget okButton = TextButton(
    child: const Text("OK"),
    onPressed: () => Navigator.pop(context, 'Cancel'),
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Register Failed"),
    content: const Text("Username already exists or is empty."),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

badPasswordAlert(BuildContext context) {
  // set up the button
  Widget okButton = TextButton(
    child: const Text("OK"),
    onPressed: () => Navigator.pop(context, 'Cancel'),
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Insecure Password"),
    content: const Text("Password is too weak."),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Future<bool> loginUser(String name, String password) async {
  if (await MongoDB.existUser(name) == false) {
    return false;
  }
  var user = await MongoDB.findUser(name);
  String storedPassword = user['password'];
  String salt = user['salt'];
  final encryptedPassword = MongoDB.hashPassWithSalt(password, salt);

  return (storedPassword == encryptedPassword);
}

Future<bool> validateUsername(String name) async {
  if (await MongoDB.existUser(name) == true) {
    return false;
  }
  if (name.isEmpty) {
    return false;
  }
  return true;
}

void pushNameLocal(String name, String password) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('username', name);
  prefs.setString('password', password);
}

void pushUserMongoDB(
    String name, String age, String dob, String password) async {
  // Generates a salt with length 10
  final salt = MongoDB.getSalt(10);
  final encryptedPassword = MongoDB.hashPassWithSalt(password, salt);

  final String uesrId = await MongoDB.createUser(name, encryptedPassword, salt);
  await MongoDB.createPatient(name, age, dob, uesrId);
}
