import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:restart_app/restart_app.dart';

import 'home_page.dart';
import 'alerts.dart';
import 'survey_page.dart';

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
            "Create User Account",
            style: TextStyle(fontFamily: "OpenSans"),
          ),
          backgroundColor: const Color(0xff0b3954),
        ),
        body: ListView(
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
                child: Container(
                  alignment: Alignment.center,
                  child: const Text(
                    "Create a user account with the same name in your patient profile.",
                    style: TextStyle(
                        fontFamily: "OpenSans",
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 18),
                    textAlign: TextAlign.center,
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
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontFamily: 'OpenSans'),
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
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontFamily: 'OpenSans'),
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
                if (!mounted) {
                  Restart.restartApp();
                }
                int result = await validateUsername(nameController.text);
                if (result != 0) {
                  if (!mounted) return;
                  validateUserFailedAlert(context, result);
                }
                if (result == 0 && _goodPassword == false) {
                  if (!mounted) return;
                  badPasswordAlert(context);
                }
                if (result == 0 && _goodPassword == true) {
                  await pushNameLocal(
                      nameController.text, passwordController.text);
                  await pushUserMongoDB(
                      nameController.text, passwordController.text);

                  if (!mounted) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          SurveyWelcomePage(name: nameController.text),
                    ),
                  );
                }
              },
            )),
          ],
        ));
  }
}
