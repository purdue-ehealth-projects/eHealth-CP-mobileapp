import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

import 'notification_api.dart';
import 'survey_page.dart';
import 'database.dart';
import 'graph_survey.dart';
import 'login_page.dart';

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
  _connectMongo() async {
    await MongoDB.connect();
  }

  _scheduleNotifs() async {
    await scheduleNotifications();
  }

  /*
  _disposeMongo() async {
    await MongoDB.cleanupDatabase();
  }
  */

  @override
  void initState() {
    super.initState();
    // cannot make initState async (need to create helper function)
    _connectMongo();

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
    _scheduleNotifs();
  }

  String _username = '';
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
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String curDate =
        '${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}';

    String? username = prefs.getString("username");
    String? password = prefs.getString("password");
    String? date = prefs.getString("date");

    if (username == null || password == null) {
      _signin = false;
    } else {
      // false if ret is not 0
      _signin = (await loginUser(username, password) == 0);
    }

    if (_signin) {
      _username = username!;
      if (date == curDate) {
        _didSurvey = true;
        _scoreToday = prefs.getInt("scoreToday")!;
        _needs = prefs.getString("needs")!;

        List<String>? scores = prefs.getStringList("scores");
        List<String>? dates = prefs.getStringList("dates");

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
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: loadLocalData(),
      builder: (context, snapshot) {
        // scoreToday == -1
        return _signin == true
            ? (_didSurvey == true
                ? GraphSurvey(
                    gSS: _graphSS,
                    scoreToday: _scoreToday,
                    name: _username,
                    needs: _needs,
                  )
                : SurveyWelcomePage(name: _username.toString()))
            : const LoginPage();
      },
    );
  }

  @override
  // implement wantKeepAlive
  bool get wantKeepAlive => true;
}

/// Login failed alert pop up
loginFailedAlert(BuildContext context, int errCode) {
  // set up the button
  Widget okButton = TextButton(
    child: const Text(
      "OK",
      style: TextStyle(fontSize: 18),
    ),
    onPressed: () => Navigator.pop(context, 'Cancel'),
  );

  // set up the AlertDialog
  AlertDialog alert = const AlertDialog();
  if (errCode == 1) {
    alert = AlertDialog(
      title: const Text(
        "Login Failed",
        style: TextStyle(fontSize: 20),
      ),
      content: const Text(
        "Wrong Password. Please try again.",
        style: TextStyle(fontSize: 18),
      ),
      actions: [
        okButton,
      ],
    );
  } else if (errCode == 2) {
    alert = AlertDialog(
      title: const Text(
        "Login Failed",
        style: TextStyle(fontSize: 20),
      ),
      content: const Text(
        "This user doesn't exist. Please create a new user account.",
        style: TextStyle(fontSize: 18),
      ),
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
    child: const Text(
      "OK",
      style: TextStyle(fontSize: 18),
    ),
    onPressed: () => Navigator.pop(context, 'Cancel'),
  );

  // set up the AlertDialog
  AlertDialog alert = const AlertDialog();
  if (errCode == 1) {
    alert = AlertDialog(
      title: const Text(
        "Register Failed",
        style: TextStyle(fontSize: 20),
      ),
      content: const Text(
        "Name cannot be empty.",
        style: TextStyle(fontSize: 18),
      ),
      actions: [
        okButton,
      ],
    );
  } else if (errCode == 2) {
    alert = AlertDialog(
      title: const Text(
        "Register Failed",
        style: TextStyle(fontSize: 20),
      ),
      content: const Text(
        "No patient profile found with given name. Please check with your paramedic.",
        style: TextStyle(fontSize: 18),
      ),
      actions: [
        okButton,
      ],
    );
  } else if (errCode == 3) {
    alert = AlertDialog(
      title: const Text(
        "Register Failed",
        style: TextStyle(fontSize: 20),
      ),
      content: const Text(
        "User with given name already exists. Please log in instead.",
        style: TextStyle(fontSize: 18),
      ),
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
    child: const Text(
      "OK",
      style: TextStyle(fontSize: 18),
    ),
    onPressed: () => Navigator.pop(context, 'Cancel'),
  );

  AlertDialog alert = AlertDialog(
    title: const Text(
      "Insecure Password",
      style: TextStyle(fontSize: 20),
    ),
    content: const Text(
      "Password is too weak.",
      style: TextStyle(fontSize: 18),
    ),
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
Future<void> pushNameLocal(String name, String password) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('username', name);
  await prefs.setString('password', password);
}

/// Register user and create user account in MongoDB.
Future<void> pushUserMongoDB(String name, String password) async {
  await MongoDB.createUser(name, password);
}

/// Returns a patient profile page for the user.
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
          var e = const Text("");
          if (entry.key == 'name') {
            e = Text(
              "${entry.key}: ${entry.value}",
              style: const TextStyle(fontSize: 18),
            );
          } else {
            e = Text("${entry.key}: ${entry.value}");
          }
          return e;
        }).toList())),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: <Widget>[
          TextButton(
            child: const Text(
              'LOG OUT',
              style: TextStyle(fontSize: 18, color: Colors.redAccent),
            ),
            onPressed: () async {
              await confirmLogout(context);
            },
          ),
          TextButton(
            child: const Text(
              'DISMISS',
              style: TextStyle(fontSize: 18),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

/// Dialog to confirm log out
confirmLogout(BuildContext context) async {
  final navigator = Navigator.of(context);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Widget okButton = TextButton(
    child: const Text(
      "LOG OUT",
      style: TextStyle(fontSize: 18, color: Colors.redAccent),
    ),
    onPressed: () async {
      await prefs.clear();
      navigator.push(
        MaterialPageRoute(
          // direct to login and not home so prefs.clear() won't get
          // called twice
          builder: (_) => const LoginPage(),
        ),
      );
    },
  );
  Widget noButton = TextButton(
    child: const Text(
      "CANCEL",
      style: TextStyle(fontSize: 18),
    ),
    onPressed: () => Navigator.pop(context, 'Cancel'),
  );

  AlertDialog alert = AlertDialog(
    title: const Text("Confirm Logout"),
    content: const Text("Are you sure you want to log out?\n\n"
        "All your local data will be cleared, and you will need to log back in again.\n\n"
        "Your paramedic will still have all your past data."),
    actionsAlignment: MainAxisAlignment.spaceBetween,
    actions: [
      okButton,
      noButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
