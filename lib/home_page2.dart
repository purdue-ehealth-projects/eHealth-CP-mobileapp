import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'notification_api.dart';
import 'notification_week_and_time.dart';

class HomePage2 extends StatelessWidget {
  const HomePage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    cancelScheduledNotifications();
    DateTime now = DateTime.now();
      NotificationWeekAndTime? nw = NotificationWeekAndTime(dayOfTheWeek: now.day + 1, timeOfDay: TimeOfDay.fromDateTime(DateTime(
          now.year, now.month, now.day + 1, 8, 0, 0, 0, 0
      )));
      createDailyReminder(nw);

      /*
      Future<bool> falsing() async {
        SystemNavigator.pop();
        return false;
      }*/

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
            Container(
              alignment: Alignment.center,
              child: Text(
                "You did your survey today! See you tomorrow!",
                style: TextStyle(
                  fontFamily: "OpenSans",
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
  }
}
