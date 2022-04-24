import 'package:emshealth/survey.dart';
import 'package:flutter/material.dart';

import 'notification_week_and_time.dart';

class CreateProfile extends StatelessWidget {

  TextEditingController nameController = new TextEditingController();
  TextEditingController ageController = new TextEditingController();
  TextEditingController dobController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  final Function pushNameLocal;
  final Function pushUserFirestore;
  final Function createHourlyReminder;

  CreateProfile({Key? key, required this.pushNameLocal, required this.pushUserFirestore, required this.createHourlyReminder,  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xff0b3954),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "EMS Health",
          style: TextStyle(
            fontFamily: "OpenSans"
          ),
        ),
        backgroundColor: Color(0xff0b3954),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 30),
              child: Container(
                alignment: Alignment.center,
                child: Text(
                    "You need to create a profile.",
                  style: TextStyle(
                    fontFamily: "OpenSans",
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 18
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
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
                textAlign: TextAlign.center,
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
                controller: ageController,
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  fillColor: Colors.transparent,
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 2,
                      )
                  ),
                  labelText: 'Age',
                  labelStyle: TextStyle(
                      color: Colors.white,
                      fontFamily: 'OpenSans',
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                  ),
                ),
                textAlign: TextAlign.center,
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
                controller: dobController,
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  fillColor: Colors.transparent,
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 2,
                      )
                  ),
                  labelText: 'Date of Birth (MM/DD/YYYY)',
                  labelStyle: TextStyle(
                      color: Colors.white,
                      fontFamily: 'OpenSans',
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                  ),
                ),
                textAlign: TextAlign.center,
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
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'OpenSans'
                ),
              ),
            ),
            SizedBox(height: 50),
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
                  "Submit",
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              onTap: () {
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
      ),
    );
  }
}
