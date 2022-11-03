import 'package:emshealth/completion_page.dart';
import 'package:emshealth/database.dart';
import 'package:emshealth/survey_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'graph_survey.dart';
import 'login_page.dart';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:emshealth/notification_api.dart';

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
class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    MongoDB.connect();
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
    // cannot make initState async (need to create helper function)
    _scheduleNotif();
  }

  /// Schedules notification
  void _scheduleNotif() async {
    await schedule24HoursAheadAN();
  }

  bool goBack = false;
  String _username = '';
  bool signin = false;
  bool didSurvey = false;
  List<SurveyScores> graphSS = [];
  int scoreToday = -1;

  @override
  void dispose() {
    //MongoDB.cleanupDatabase();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: loadLocalData(),
      builder: (context, snapshot) {
        // scoreToday == -1
        return didSurvey == false
            ? (signin
                ? SurveyWelcomePage(username: _username.toString())
                : const LoginPage())
            : GraphSurvey(
                gSS: graphSS, scoreToday: scoreToday, name: _username);
      },
    );
  }

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
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String curDate =
        '${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}';

    String? username = prefs.getString("username");
    String? password = prefs.getString("password");
    String? date = prefs.getString("date");

    if (username == null || password == null) {
      signin = false;
    } else {
      // false if ret is not 0
      signin = (await loginUser(username, password) == 0);
    }

    if (signin) {
      _username = username!;
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
    } else {
      await prefs.clear();
    }
  }

  @override
  // implement wantKeepAlive
  bool get wantKeepAlive => true;
}

/// Login failed alert pop up
loginFailedAlert(BuildContext context, int errCode) {
  // set up the button
  Widget okButton = TextButton(
    child: const Text("OK"),
    onPressed: () => Navigator.pop(context, 'Cancel'),
  );

  // set up the AlertDialog
  AlertDialog alert = const AlertDialog();
  if (errCode == 1) {
    alert = AlertDialog(
      title: const Text("Login Failed"),
      content: const Text("Wrong Password. Please try again."),
      actions: [
        okButton,
      ],
    );
  } else if (errCode == 2) {
    alert = AlertDialog(
      title: const Text("Login Failed"),
      content: const Text("User doesn't exist. Please create a user account."),
      actions: [
        okButton,
      ],
    );
  }

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

/// Register failed alert pop up
validateUserFailedAlert(BuildContext context, int errCode) {
  // set up the button
  Widget okButton = TextButton(
    child: const Text("OK"),
    onPressed: () => Navigator.pop(context, 'Cancel'),
  );

  // set up the AlertDialog
  AlertDialog alert = const AlertDialog();
  if (errCode == 1) {
    alert = AlertDialog(
      title: const Text("Register Failed"),
      content: const Text("Username cannot be empty."),
      actions: [
        okButton,
      ],
    );
  } else if (errCode == 2) {
    alert = AlertDialog(
      title: const Text("Register Failed"),
      content: const Text(
          "This user doesn't have a patient profile. Please check with your paramedic."),
      actions: [
        okButton,
      ],
    );
  } else if (errCode == 3) {
    alert = AlertDialog(
      title: const Text("Register Failed"),
      content: const Text(
          "User with username already exists. Please log in instead."),
      actions: [
        okButton,
      ],
    );
  }

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

/// Bad password alert pop up
badPasswordAlert(BuildContext context) {
  Widget okButton = TextButton(
    child: const Text("OK"),
    onPressed: () => Navigator.pop(context, 'Cancel'),
  );

  AlertDialog alert = AlertDialog(
    title: const Text("Insecure Password"),
    content: const Text("Password is too weak."),
    actions: [
      okButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

/// Helper function log in user. Returns an error code.
///
/// @Return: 0 - no error; 1 - wrong password; 2 - user doesn't exist.
Future<int> loginUser(String name, String password) async {
  if (await MongoDB.existUser(name) == false) {
    return 2;
  }
  var user = await MongoDB.findUser(name);
  String storedPassword = user['password'];
  String salt = user['salt'];
  final encryptedPassword = MongoDB.hashPassWithSalt(password, salt);

  if (storedPassword == encryptedPassword) {
    return 0;
  } else {
    return 1;
  }
}

/// Ensure that a patient profile for user already exists. Returns an error
/// code.
///
/// @Return: 0 - no error; 1 - empty input; 2 - patient profile doesn't exist;
/// 3 - user account already exists.
Future<int> validateUsername(String name) async {
  if (name.isEmpty) {
    return 1;
  }
  if (await MongoDB.existPatient(name) == false) {
    return 2;
  }
  if (await MongoDB.existUser(name) == true) {
    return 3;
  }
  return 0;
}

/// Push name and password to storage
void pushNameLocal(String name, String password) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('username', name);
  prefs.setString('password', password);
}

/// Register user and create user account in MongoDB.
void pushUserMongoDB(String name, String password) async {
  await MongoDB.createUser(name, password);
}

Future<void> showProfile(BuildContext context, String name) async {
  Map<String, dynamic> patient = await MongoDB.findPatient(name);
  patient.removeWhere((key, value) => key == '_id');

  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Patient Profile Page'),
        content: SingleChildScrollView(
            child: ListBody(
                children: patient.entries.map((entry) {
          var w = Text("${entry.key}: ${entry.value}");
          return w;
        }).toList())),
        actions: <Widget>[
          TextButton(
            child: const Text('DISMISS'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
