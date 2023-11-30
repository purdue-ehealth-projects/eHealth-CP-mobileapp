import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restart_app/restart_app.dart';
import 'dart:io' show Platform;

import 'survey_page.dart';
import 'create_profile.dart';
import 'database.dart';
import 'alerts.dart';
import 'buttons.dart';

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
    final Size size = MediaQuery.of(context).size;

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: const Text(
                "EMS Health Home Page",
                style: TextStyle(fontFamily: "OpenSans"),
              ),
              leading: privacyPolicyButton(context),
              trailing: userManButton(context),
              backgroundColor: CupertinoColors.systemBlue, // Customize the navigation bar color
            ),
            child: CustomScrollView(
              slivers: <Widget>[
                CupertinoSliverRefreshControl(
                  onRefresh: () async {
                    // Refresh functionality
                  },
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 30, bottom: 20),
                        child:
                            Image.asset("assets/icon3_home.png", height: 150),
                      ),
                      Center(
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              width: size.width * 0.8,
                              child: CupertinoTextField(
                                controller: nameController,
                                placeholder: 'Name',
                                placeholderStyle: const TextStyle(
                                  color: CupertinoColors.inactiveGray,
                                ),
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: CupertinoColors.black,
                                  fontFamily: 'OpenSans',
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: size.width * 0.8,
                              child: CupertinoTextField(
                                controller: passwordController,
                                placeholder: 'Password',
                                placeholderStyle: const TextStyle(
                                  color: CupertinoColors.inactiveGray,
                                ),
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: CupertinoColors.black,
                                  fontFamily: 'OpenSans',
                                ),
                                obscureText: true,
                              ),
                            ),
                            const SizedBox(height: 40),
                            CupertinoButton.filled(
                              child: Container(
                                width: size.width * 0.5,
                                height: 50,
                                // decoration: BoxDecoration(
                                //   borderRadius: const BorderRadius.all(Radius.circular(15)),
                                //   border: Border.all(
                                //     color: CupertinoColors.black,
                                //     width: 2,
                                //   ),
                                // ),
                                alignment: Alignment.center,
                                child: const Text(
                                  "Login",
                                  style: TextStyle(
                                    fontFamily: 'OpenSans',
                                    color: CupertinoColors.black,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                await loginOntap(nameController.text,
                                    passwordController.text);
                              },
                            ),
                            const SizedBox(height: 20),
                            CupertinoButton.filled(
                              child: Container(
                                width: size.width * 0.5,
                                height: 50,
                                // decoration: BoxDecoration(
                                //   borderRadius: const BorderRadius.all(Radius.circular(15)),
                                //   border: Border.all(
                                //     color: CupertinoColors.black,
                                //     width: 2,
                                //   ),
                                // ),
                                alignment: Alignment.center,
                                child: const Text(
                                  "Create User",
                                  style: TextStyle(
                                    fontFamily: 'OpenSans',
                                    color: CupertinoColors.black,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w900,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (_) => const CreateProfile(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : Scaffold(
            backgroundColor: const Color(0xff0b3954),
            appBar: AppBar(
              centerTitle: true,
              title: const Text(
                "EMS Health Home Page",
                style: TextStyle(fontFamily: "OpenSans"),
              ),
              backgroundColor: const Color(0xff0b3954),
              leading: privacyPolicyButton(context),
              actions: [userManButton(context)],
            ),
            body: ListView(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(top: 30, bottom: 20),
                  child: Image(
                    image: AssetImage("assets/icon3_home.png"),
                    height: 150,
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
                              passwordController.value =
                                  passwordController.value;
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
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        onTap: () async {
                          await loginOntap(
                              nameController.text, passwordController.text);
                        },
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        child: Container(
                          width: size.width * 0.8,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            "Create User Account",
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              color: Colors.white,
                              fontSize: 26,
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
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  Future<void> loginOntap(String name, String password) async {
    if (!mounted) {
      Restart.restartApp();
    }
    String parsedName = parseName(name);
    int result = await loginUser(parsedName, password);
    if (result != 0) {
      if (!mounted) return;
      loginFailedAlert(context, result);
    } else {
      await pushUserLocal(parsedName, passwordController.text);

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SurveyWelcomePage(name: parsedName),
        ),
      );
    }
  }
}
