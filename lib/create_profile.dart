import 'package:emshealth/survey_page.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';
import 'notification_api.dart';
import 'notification_week_and_time.dart';

import 'package:flutter_pw_validator/flutter_pw_validator.dart';

/// Create profile page that is pushed from the login page to create a new
/// profile.
class CreateProfile extends StatefulWidget {
  const CreateProfile({Key? key}) : super(key: key);

  @override
  State<CreateProfile> createState() => _CreateProfileState();
}

/// Create profile page state.
class _CreateProfileState extends State<CreateProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _goodPassword = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: const Color(0xff0b3954),
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "EMS Health",
            style: TextStyle(fontFamily: "OpenSans"),
          ),
          backgroundColor: const Color(0xff0b3954),
        ),
        body: ListView(
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 30),
                child: Container(
                  alignment: Alignment.center,
                  child: const Text(
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
            const SizedBox(height: 20),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: size.width * 0.9,
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
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
                  style: const TextStyle(
                      color: Colors.white, fontFamily: 'OpenSans'),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: size.width * 0.9,
                child: TextField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: const InputDecoration(
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
                  style: const TextStyle(
                      color: Colors.white, fontFamily: 'OpenSans'),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: size.width * 0.9,
                child: FlutterPwValidator(
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
            const SizedBox(height: 10),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: size.width * 0.9,
                child: TextField(
                  controller: ageController,
                  decoration: const InputDecoration(
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
                  style: const TextStyle(
                      color: Colors.white, fontFamily: 'OpenSans'),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: size.width * 0.9,
                child: TextField(
                  controller: dobController,
                  decoration: const InputDecoration(
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
                  style: const TextStyle(
                      color: Colors.white, fontFamily: 'OpenSans'),
                ),
              ),
            ),
            const SizedBox(height: 50),
            Center(
                child: GestureDetector(
              child: Container(
                width: size.width * 0.8,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                alignment: Alignment.center,
                child: const Text(
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
                  if (!mounted) return;
                  registerFailedAlert(context);
                }
                if (result == true && _goodPassword == false) {
                  if (!mounted) return;
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

                  if (!mounted) return;
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
