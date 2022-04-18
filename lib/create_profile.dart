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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("EMS Health"),
        backgroundColor: Color(0xff0b3954),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                alignment: Alignment.center,
                child: Text("You need to create a profile."),
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: ageController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Age',
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: dobController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Date of Birth (MM/DD/YYYY)',
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xff0b3954)),
              ),
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
      ),
    );
  }
}
