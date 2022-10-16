import 'package:emshealth/survey_page.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';
import 'notification_api.dart';
import 'notification_week_and_time.dart';

import 'package:flutter_pw_validator/flutter_pw_validator.dart';

class CreateProfile extends StatefulWidget {
  CreateProfile({Key? key}) : super(key: key);

  @override
  State<CreateProfile> createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController ageController = new TextEditingController();
  TextEditingController dobController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  bool _goodPassword = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Color(0xff0b3954),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "EMS Health",
            style: TextStyle(fontFamily: "OpenSans"),
          ),
          backgroundColor: Color(0xff0b3954),
        ),
        body: ListView(
          children: <Widget>[
            Center(
              child: Padding(
                padding: EdgeInsets.only(left: 10, right: 10, top: 30),
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    "You need to create a profile.",
                    style: TextStyle(
                        fontFamily: "OpenSans",
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 18),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                width: size.width * 0.9,
                child: TextField(
                  controller: nameController,
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
                  style: TextStyle(color: Colors.white, fontFamily: 'OpenSans'),
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                width: size.width * 0.9,
                child: TextField(
                  obscureText: true,
                  controller: passwordController,
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
                  style: TextStyle(color: Colors.white, fontFamily: 'OpenSans'),
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                width: size.width * 0.9,
                child: new FlutterPwValidator(
                    controller: passwordController,
                    minLength: 6,
                    uppercaseCharCount: 1,
                    numericCharCount: 1,
                    specialCharCount: 0,
                    width: 400,
                    height: 90,
                    onSuccess: () {
                      setState(() {
                        _goodPassword = true;
                      });
                    },
                    onFail: () {
                      setState(() {
                        _goodPassword = false;
                      });
                    }),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                width: size.width * 0.9,
                child: TextField(
                  controller: ageController,
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    fillColor: Colors.transparent,
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.white,
                      width: 2,
                    )),
                    labelText: 'Age',
                    labelStyle: TextStyle(
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  style: TextStyle(color: Colors.white, fontFamily: 'OpenSans'),
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                width: size.width * 0.9,
                child: TextField(
                  controller: dobController,
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    fillColor: Colors.transparent,
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.white,
                      width: 2,
                    )),
                    labelText: 'Date of Birth (MM/DD/YYYY)',
                    labelStyle: TextStyle(
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  style: TextStyle(color: Colors.white, fontFamily: 'OpenSans'),
                ),
              ),
            ),
            SizedBox(height: 50),
            Center(
                child: GestureDetector(
              child: Container(
                width: size.width * 0.8,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Submit",
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              onTap: () async {
                bool result = await validateUsername(nameController.text);
                if (result == false) {
                  registerFailedAlert(context);
                }
                if (result == true && _goodPassword == false) {
                  badPasswordAlert(context);
                }
                if (result == true && _goodPassword == true) {
                  pushNameLocal(nameController.text, passwordController.text);
                  pushUserMongoDB(nameController.text, ageController.text,
                      dobController.text, passwordController.text);

                  cancelScheduledNotifications();
                  NotificationWeekAndTime? nw = NotificationWeekAndTime(
                      dayOfTheWeek: DateTime.now().day,
                      timeOfDay: TimeOfDay.fromDateTime(DateTime.now()));
                  createHourlyReminder(nw);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          SurveyWelcomePage(username: nameController.text),
                    ),
                  );
                }
              },
            )),
          ],
        ));
  }
}
