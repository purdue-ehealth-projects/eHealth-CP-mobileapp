import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:emshealth/notification_api.dart';
import 'package:emshealth/survey.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'notification_week_and_time.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool markDoneForMin = false;
  String? username = '';
  bool signin = false;
  bool didSurvey = false;

  @override
  void initState() {
    super.initState();

    //get local data
    loadLocalData();

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

    AwesomeNotifications().createdStream.listen((notification) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Notification Created on ${notification.channelKey}',
        ),
      ));
    });

    AwesomeNotifications().actionStream.listen((notification) {
      if (notification.channelKey == 'basic_channel' && Platform.isIOS) {
        AwesomeNotifications().getGlobalBadgeCounter().then(
              (value) =>
              AwesomeNotifications().setGlobalBadgeCounter(value - 1),
        );
      }

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => SurveyPage(name: username.toString()),
        ),
            (route) => route.isFirst,
      );

      if (notification.channelKey == 'daily_channel') {
        if (!markDoneForMin) {
          NotificationWeekAndTime? nw = NotificationWeekAndTime(dayOfTheWeek: DateTime.now().day, timeOfDay: TimeOfDay.now());
          createHourlyReminder(nw);
        }
      }

    });

    if (signin == true) {
      NotificationWeekAndTime? nw = NotificationWeekAndTime(dayOfTheWeek: DateTime.now().day, timeOfDay: TimeOfDay.fromDateTime(DateTime.now().add(Duration(seconds: 120))));
      createDailyReminder(nw);
    }

  }

  Future<void> loadLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('username')) {
      username = prefs.getString('username');
      signin = true;
    } else {
      username = '';
      signin = false;
    }
    print("username: " + username!);

    String time = DateTime.now().year.toString() + ' ' + DateTime.now().month.toString() + ' ' + DateTime.now().day.toString();
    if (prefs.containsKey('date')) {
      String? prevDate = prefs.getString('date');
      if (prevDate.toString().compareTo(time) == 0) {
        //did survey before
        didSurvey = true;
      } else {
        didSurvey = false;
      }
    } else {
      didSurvey = false;
    }

    print('signin: $signin');
    print('didsurvey: $didSurvey');

  }

  void pushNameLocal(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', name);
  }

  void pushUserFirestore(String name, String age, String dob, String password) async {
    CollectionReference patients = FirebaseFirestore.instance.collection('patients');
    QuerySnapshot query = await patients.where('name', isEqualTo: '$name').get();
    QueryDocumentSnapshot doc = query.docs[0];
    DocumentReference docRef = doc.reference;
    docRef.update({'password': password});
    print("Success");
  }

  void changeMark() {
    markDoneForMin = true;
    cancelScheduledNotifications();
    NotificationWeekAndTime? nw = NotificationWeekAndTime(dayOfTheWeek: DateTime.now().day, timeOfDay: TimeOfDay.fromDateTime(DateTime.now().add(Duration(seconds: 120))));
    createDailyReminder(nw);
    markDoneForMin = false;
  }

  @override
  void dispose() {
    AwesomeNotifications().actionSink.close();
    AwesomeNotifications().createdSink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = new TextEditingController();
    TextEditingController ageController = new TextEditingController();
    TextEditingController dobController = new TextEditingController();
    TextEditingController passwordController = new TextEditingController();

    return FutureBuilder(
      future: loadLocalData(),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("EMS Health"),
          ),
          body: username == null || username == '' ?
          Center(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text("You need to create a profile."),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'name',
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  child: TextField(
                    controller: ageController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'age',
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  child: TextField(
                    controller: dobController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'date of birth (MM/DD/YYYY)',
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  child: TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'password',
                    ),
                  ),
                ),
                ElevatedButton(
                  child: Text("Submit"),
                  onPressed: () {
                    //save name on local data
                    pushNameLocal(nameController.text);

                    //save name on storage
                    pushUserFirestore(nameController.text, ageController.text, dobController.text, passwordController.text);

                    //then only create notification
                    NotificationWeekAndTime? nw = NotificationWeekAndTime(dayOfTheWeek: DateTime.now().day, timeOfDay: TimeOfDay.fromDateTime(DateTime.now()));
                    createHourlyReminder(nw);

                    //go to survey page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SurveyPage(name: nameController.text),
                      ),
                    );

                  },
                )
              ],
            ),
          ) :
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: !didSurvey ? ElevatedButton(
                    child: Text("Click to go to survey"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SurveyPage(name: username.toString()),
                        ),
                      );
                    },
                  ) :
                  Text("You did your survey today! See you tomorrow!"),
                ),
              ],
            ),
          ),
        );
      },
    );


  }
}
