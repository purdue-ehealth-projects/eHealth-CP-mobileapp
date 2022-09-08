import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:emshealth/completion_page.dart';
import 'package:emshealth/create_profile.dart';
import 'package:emshealth/notification_api.dart';
import 'package:emshealth/survey_2.dart';
import 'package:encrypt/encrypt.dart' as E;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xid/xid.dart';
import 'graph_survey.dart';
import 'home_page2.dart';
import 'login_page.dart';
import 'notification_week_and_time.dart';

class HomePage extends StatefulWidget {

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {

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
    DateTime now = DateTime.now();

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Allow Notifications'),
            content: Text('Our app would like to send you notifications'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
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
                  child: Text(
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

      //get username
      SharedPreferences.getInstance().then((prefs) {
        String usernameP = prefs.getString('username').toString();

        //check if survey's done today
        String surveyDate = prefs.getString('date').toString();
        DateTime now = DateTime.now();
        String time = now.year.toString() + ' ' + now.month.toString() + ' ' + now.day.toString();

        if (surveyDate != null && surveyDate != "" && surveyDate.compareTo(time) != 0) {
          //not yet did survey
          didSurvey == false;
        }
        // --- get data done ---

        //no username in local data
        if (usernameP == null || usernameP == "" || usernameP.isEmpty || usernameP.compareTo("null") == 0) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => LoginPage(),
            ),
                (route) => route.isFirst,
          );
        } else {
          //have username in local data
          //if done survey for the day
          if (didSurvey) {
            List<int> x = [];     //score
            List<String> y = [];  //date

            List<String>? scores = prefs.getStringList("scores");
            for (String? score in scores!) {
              if (score.toString().isNotEmpty && score.toString().length != 0)
                x.add(int.parse(score.toString()));
            }
            List<String>? dates = prefs.getStringList("dates");
            for (String? date in dates!) {
              if (date.toString().isNotEmpty && date.toString().length != 0)
                y.add(date.toString());
            }

            graphSS = []; //reset
            for (int i = dates.length - 1; i >= 0; i--) {
              graphSS.add(new SurveyScores(y[i], x[i]));
              print('${y[i]}, ${x[i]}');
            }
            scoreToday = prefs.getInt("scoreToday")!;
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => HomePage2(gSS: graphSS, scoreToday: scoreToday),
              ),
                  (route) => route.isFirst,
            );
          } else {
            //not yet done survey
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => SurveyWelcomePage(username: usernameP),
              ),
                  (route) => route.isFirst,
            );
          }
        }

      });
      });
  }

  Future<void> loadLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String curDate = DateTime.now().year.toString() + ' ' + DateTime.now().month.toString() + ' ' + DateTime.now().day.toString();

    String? username = prefs.getString("username");
    String? password = prefs.getString("password");
    String? date = prefs.getString("date");

    if (username != null && username != "" && password != null && username != "") {
      signin = true;
      if (date == curDate) {
        didSurvey = true;
        scoreToday = prefs.getInt("scoreToday")!;

        List<String>? scores = prefs.getStringList("scores");
        List<String>? dates = prefs.getStringList("dates");

        if (scores != null && dates != null) {
          for (int i = 0; i < scores.length; i++) {
            graphSS.add(new SurveyScores(dates[i], int.parse(scores[i])));
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
    super.dispose();
  }
  TextEditingController nameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (didSurvey) {
      cancelScheduledNotifications();
      DateTime now = DateTime.now();
      NotificationWeekAndTime? nw = NotificationWeekAndTime(dayOfTheWeek: now.day + 1, timeOfDay: TimeOfDay.fromDateTime(DateTime(
          now.year, now.month, now.day + 1, 8, 0, 0, 0, 0
      )));
      createDailyReminder(nw);
    }

    return FutureBuilder(
      future: loadLocalData(),
      builder: (context, snapshot) {
        Size size = MediaQuery.of(context).size;
        return Scaffold(
          backgroundColor: Color(0xff0b3954),
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "EMS Health Home Page",
              style: TextStyle(
                  fontFamily: "OpenSans"
              ),
            ),
            backgroundColor: Color(0xff0b3954),
            leading: (didSurvey == true) ? Container() : null,
          ),
          body: ListView(
            children: <Widget>[
              scoreToday == -1 ?
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  "EMS",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "OpenSans",
                    fontWeight: FontWeight.w700,
                    fontSize: 80,
                    color: Colors.white,
                  ),
                ),
              ) : Container(),
              scoreToday == -1 ?
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Text(
                  "Health",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "OpenSans",
                    fontWeight: FontWeight.w700,
                    fontSize: 52,
                    color: Colors.white,
                  ),
                ),
              ) : Container(),
              !signin ?
              Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      width: size.width * 0.9,
                      child: TextField(
                        controller: nameController,
                        onChanged: (val) {
                          setState(() {
                            nameController.value = nameController.value;
                          });
                        },
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          fillColor: Colors.transparent,
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 2,
                              )
                          ),
                          labelText: 'Name',
                          labelStyle: TextStyle(
                              color: Colors.white,
                              fontFamily: 'OpenSans',
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'OpenSans'
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      width: size.width * 0.9,
                      child: TextField(
                        obscureText: true,
                        controller: passwordController,
                        onChanged: (val) {
                          setState(() {
                            passwordController.value = passwordController.value;
                          });
                        },
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          fillColor: Colors.transparent,
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 2,
                              )
                          ),
                          labelText: 'Password',
                          labelStyle: TextStyle(
                              color: Colors.white,
                              fontFamily: 'OpenSans',
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'OpenSans'
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    GestureDetector(
                      child: Container(
                        width: size.width * 0.8,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Login",
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      onTap: () {
                        loginUser(nameController.text, passwordController.text).then((result) {
                          if (result) {
                            pushNameLocal(nameController.text, passwordController.text);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SurveyWelcomePage(username: nameController.text),
                              ),
                            );
                          } else {
                            loginFailedAlert(context);
                          }
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      child: Container(
                        width: size.width * 0.8,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Create a Profile",
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CreateProfile(pushNameLocal: pushNameLocal, pushUserFirestore: pushUserFirestore, createHourlyReminder: createHourlyReminder),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ) :
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: !didSurvey ? GestureDetector(
                        child: Container(
                          width: size.width * 0.8,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Click to go to Survey",
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SurveyWelcomePage(username: username.toString()),
                            ),
                          );
                        },
                      ) :
                      GraphSurvey(graphSS, scoreToday),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

loginFailedAlert(BuildContext context) {
  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () => Navigator.pop(context, 'Cancel'),
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Login Failed"),
    content: Text("Wrong username or password. Please try again."),
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
  CollectionReference patients = FirebaseFirestore.instance.collection('users');
  QuerySnapshot query = await patients.where('name', isEqualTo: '$name').get();
  if (query == null || query.size == 0) return false;
  else {
    QueryDocumentSnapshot doc = query.docs[0];
    DocumentReference docRecord = doc.reference;
    DocumentSnapshot docRecSnap = await docRecord.get();
    var rec = docRecSnap.data().toString();

    //parse password
    int idx = rec.indexOf('password:');
    rec = rec.substring(idx + 10);
    idx = rec.indexOf(',');
    rec = rec.substring(0, idx);


    final key = E.Key.fromLength(32);
    final iv = E.IV.fromLength(16);
    final encrypter = E.Encrypter(E.AES(key));

    final encrypted = encrypter.encrypt(password, iv: iv).base64;

    if (rec.compareTo(encrypted) == 0) return true;
    else return false;
  }
}

void pushNameLocal(String name, String password) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('username', name);
  prefs.setString('password', password);
}

void pushUserFirestore(String name, String age, String dob, String password) async {

  //generate a userId
  Xid userId = Xid();

  //generate password
  final key = E.Key.fromLength(32);
  final iv = E.IV.fromLength(16);
  final encrypter = E.Encrypter(E.AES(key));

  final encrypted = encrypter.encrypt(password, iv: iv).base64;

  //update patient part
  CollectionReference patients = FirebaseFirestore.instance.collection('patients');
  QuerySnapshot query = await patients.where('name', isEqualTo: '$name').get();
  if (query.docs.isEmpty ) {
    patients.add({
      'address': '',
      'age': 0,
      'appointment_day': '',
      'chest': '',
      'contact_1': '',
      'contact_2': '',
      'coords': FieldValue.arrayUnion([0, 0]),
      'gender_id': '',
      'medical_history': '',
      'overall': '',
      'priority': 3,
      'program': '',
      'race': '',
      'start_date': '',
      'stomach': '',
      'zone': 0,
      'name': name,
      'userId': userId.toString(),
    });
  } else {
    QueryDocumentSnapshot doc = query.docs[0];
    DocumentReference docRef = doc.reference;
    docRef.update({'userId': userId.toString()});
  }

  //update profile part
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  users.add({
    'name': name,
    'userId': userId.toString(),
    'password': encrypted,
  });
}