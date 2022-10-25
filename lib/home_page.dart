import 'package:emshealth/completion_page.dart';
import 'package:emshealth/database.dart';
import 'package:emshealth/main.dart';
import 'package:emshealth/survey_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'graph_survey.dart';
import 'login_page.dart';

/// Main Homepage that gets called in main.
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

/// Homepage state
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
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
  }

  /// Load local date from storage to app memory
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
    MongoDB.cleanupDatabase();
    super.dispose();
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return FutureBuilder(
      future: loadLocalData(),
      builder: (context, snapshot) {
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

/// Login failed alert pop up
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

/// Register failed alert pop up
registerFailedAlert(BuildContext context, int errCode) {
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

/// Helper function log in user.
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

/// Ensure that a patient profile for user already exists.
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

/// Register user and create user & patient profiles in MongoDB by calling
/// respective functions in database.dart.
void pushUserMongoDB(String name, String password) async {
  // Generates a salt with length 10
  final salt = MongoDB.getSalt(10);
  final encryptedPassword = MongoDB.hashPassWithSalt(password, salt);

  await MongoDB.createUser(name, encryptedPassword, salt);
  //await MongoDB.createPatient(name, age, dob, uesrId);
}
