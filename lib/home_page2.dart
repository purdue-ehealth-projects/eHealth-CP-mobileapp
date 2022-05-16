import 'package:emshealth/completion_page.dart';
import 'package:emshealth/graph_survey.dart';
import 'package:flutter/material.dart';

import 'notification_api.dart';
import 'notification_week_and_time.dart';

class HomePage2 extends StatelessWidget {

  final List<SurveyScores> gSS;
  final int scoreToday;

  const HomePage2({Key? key, required this.gSS, required this.scoreToday}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    DateTime dt = DateTime.now();
    cancelScheduledNotifications();
    NotificationWeekAndTime? nw = NotificationWeekAndTime(dayOfTheWeek: dt.day + 1, timeOfDay: TimeOfDay.fromDateTime(DateTime(
        dt.year, dt.month, dt.day + 1, 8, 0, 0, 0, 0
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
        body: ListView(
          children: <Widget>[
            GraphSurvey(gSS, scoreToday),
          ],
        ),
      );
  }
}
