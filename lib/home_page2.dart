import 'package:flutter/material.dart';

import 'notification_api.dart';
import 'notification_week_and_time.dart';

class HomePage2 extends StatelessWidget {
  const HomePage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    DateTime now = DateTime.now();
      cancelScheduledNotifications();
      NotificationWeekAndTime? nw = NotificationWeekAndTime(dayOfTheWeek: now.day + 1, timeOfDay: TimeOfDay.fromDateTime(DateTime(
          now.year, now.month, now.day + 1, 8, 0, 0, 0, 0
      )));
      createDailyReminder(nw);

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
      body: Container(
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
    );
  }
}
