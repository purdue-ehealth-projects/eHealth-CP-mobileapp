import 'package:emshealth/survey_2.dart';
import 'package:flutter/material.dart';

import 'create_profile.dart';
import 'home_page.dart';
import 'notification_api.dart';
import 'notification_week_and_time.dart';

import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xff0b3954),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "EMS Health Home Page",
          style: TextStyle(fontFamily: "OpenSans"),
        ),
        backgroundColor: Color(0xff0b3954),
        leading: Container(),
      ),
      body: ListView(
        children: <Widget>[
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
          ),
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
          ),
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
                      )),
                      labelText: 'Name',
                      labelStyle: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    style:
                        TextStyle(color: Colors.white, fontFamily: 'OpenSans'),
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
                      )),
                      labelText: 'Password',
                      labelStyle: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    style:
                        TextStyle(color: Colors.white, fontFamily: 'OpenSans'),
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
                    loginUser(nameController.text, passwordController.text)
                        .then((result) {
                      pushNameLocal(
                          nameController.text, passwordController.text);
                      if (result) {
                        cancelScheduledNotifications();
                        NotificationWeekAndTime? nw = NotificationWeekAndTime(
                            dayOfTheWeek: DateTime.now().day,
                            timeOfDay: TimeOfDay.fromDateTime(DateTime.now()));
                        createHourlyReminder(nw);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SurveyWelcomePage(
                                username: nameController.text),
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
                        builder: (_) => CreateProfile(
                            pushNameLocal: pushNameLocal,
                            pushUserFirestore: pushUserFirestore,
                            createHourlyReminder: createHourlyReminder),
                      ),
                    );
                  },
                ),
                SizedBox(height: 20),
                GestureDetector(
                  child: Container(
                    width: size.width * 0.8,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Privacy Policy",
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  onTap: () => launchUrl(Uri.parse(
                      'https://gist.github.com/carl2x/3b79730cdd9ae5f8d746c817d2772a2a')),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
