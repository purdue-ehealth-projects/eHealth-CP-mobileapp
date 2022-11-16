import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'survey_page.dart';
import 'create_profile.dart';
import 'home_page.dart';

/// Login page that is shown when the user is not logged in.
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

/// Login page state.
class _LoginPageState extends State<LoginPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xff0b3954),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "EMS Health Home Page",
          style: TextStyle(fontFamily: "OpenSans"),
        ),
        backgroundColor: const Color(0xff0b3954),
        leading: Container(),
      ),
      body: ListView(
        children: <Widget>[
          const Padding(
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
          const Padding(
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
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  width: size.width * 0.9,
                  child: TextField(
                    controller: nameController,
                    onChanged: (val) {
                      setState(() {
                        nameController.value = nameController.value;
                      });
                    },
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
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  width: size.width * 0.9,
                  child: TextField(
                    obscureText: true,
                    controller: passwordController,
                    onChanged: (val) {
                      setState(() {
                        passwordController.value = passwordController.value;
                      });
                    },
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
                const SizedBox(height: 40),
                GestureDetector(
                  child: Container(
                    width: size.width * 0.8,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  onTap: () async {
                    int result = await loginUser(
                        nameController.text, passwordController.text);
                    if (result != 0) {
                      if (!mounted) return;
                      loginFailedAlert(context, result);
                    } else {
                      await pushNameLocal(
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
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  child: Container(
                    width: size.width * 0.8,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      "Create User Account",
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
                        builder: (_) => const CreateProfile(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 40),
                GestureDetector(
                  child: Container(
                    width: size.width * 0.8,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      "Privacy Policy",
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  onTap: () => launchUrl(
                      Uri.parse(
                          'https://gist.github.com/carl2x/3b79730cdd9ae5f8d746c817d2772a2a'),
                      mode: LaunchMode.platformDefault),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
