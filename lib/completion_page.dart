import 'package:emshealth/graph_survey.dart';
import 'package:emshealth/notification_api.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:xid/xid.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'notification_week_and_time.dart';

class CompletionPage extends StatelessWidget {
final int score;
final String needs;
final String name;
final Map<String, String> quizResult;
CompletionPage({Key? key, required this.score, required this.needs, required this.name, required this.quizResult}) : super(key: key);
List<SurveyScores> ss = [];

Future<void> updateDatabase() async {
  await cancelScheduledNotifications();

  String time = DateTime.now().year.toString() + ' ' + DateTime.now().month.toString() + ' ' + DateTime.now().day.toString();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? dates = prefs.getStringList("dates");
  List<String>? scores = prefs.getStringList("scores");
  if (!(dates != null && dates.isNotEmpty && scores != null && scores.isNotEmpty)) {
    dates = [];
    scores = [];
  }
  dates.add(time);
  scores.add(score.toString());

  for (int i = 0; i < dates.length; i++) {
    ss.add(new SurveyScores(dates[i], int.parse(scores[i])));
  }
  
  prefs.setInt("scoreToday", score);
  prefs.setString('date', time);
  prefs.setStringList("dates", dates);
  prefs.setStringList("scores", scores);

  // UPDATE DATABASE HERE

}

@override
Widget build(BuildContext context) {


  Future<bool> falsing() async {
    return false;
  }

  return FutureBuilder(
    future: updateDatabase(),
    builder: (context, snapshot) {

      DateTime dt = DateTime.now();
      cancelScheduledNotifications();
      NotificationWeekAndTime? nw = NotificationWeekAndTime(dayOfTheWeek: dt.day + 1, timeOfDay: TimeOfDay.fromDateTime(DateTime(
        dt.year, dt.month, dt.day + 1, 8, 0, 0, 0, 0
      )));
      createDailyReminder(nw);

      Size size = MediaQuery.of(context).size;

      return WillPopScope(
        child: Scaffold(
          backgroundColor: Color(0xff0b3954),
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Great Job!',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: "OpenSans"
              ),
            ),
            backgroundColor: Color(0xff0b3954),
            elevation: 0,
            leading: null,
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
                Container(
                  child: GestureDetector(
                    child: Container(
                      height: 40,
                      width: size.width * 0.6,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Color(0xff087e8b),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 10),
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 10,
                            ),
                          ]
                      ),
                      child: Text(
                        "Go back to Home Page",
                        style: TextStyle(
                          fontFamily: "OpenSans",
                          fontSize: 18,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    onTap: () {
                      Navigator.popUntil(context, (route) => route.isFirst);

                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(
                        builder: (_) => GraphSurvey(ss, score),
                      ));
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Your score today: ",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "OpenSans",
                                  color: Colors.white
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: (score >= 0 && score <= 20) ? Colors.green : ((score >= 25 && score <= 35 ? Colors.yellow : Colors.red )),
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "$score",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "OpenSans"
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Your needs today: ",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "OpenSans",
                                  color: Colors.white
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Container(
                                height: 50,
                                alignment: Alignment.center,
                                child: Text(
                                  "$needs",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "OpenSans",
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      "Your next survey will be at 8am tomorrow.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: "OpenSans",
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Container(
                    child: Text(
                      "Your past 5 records: ",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: "OpenSans",
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
                Container(
                    padding: const EdgeInsets.all(5),
                    height: 400,
                    width: double.infinity,
                    child: SfCartesianChart(
                      plotAreaBackgroundColor: Colors.transparent,
                      primaryXAxis: CategoryAxis(
                        borderColor: Colors.transparent,
                        labelRotation: 90,
                        autoScrollingMode: AutoScrollingMode.start,
                        labelStyle: TextStyle(
                          fontFamily: "OpenSans",
                          color: Colors.white,
                        ),
                          majorGridLines: MajorGridLines(
                              color: Colors.transparent
                          )
                      ),
                      primaryYAxis: CategoryAxis(
                        borderColor: Colors.transparent,
                        labelStyle: TextStyle(
                          fontFamily: "OpenSans",
                          color: Colors.white,
                        ),
                        majorGridLines: MajorGridLines(
                          color: Colors.transparent
                        ),
                        isInversed: true,
                      ),
                      series: <ChartSeries>[
                        LineSeries<SurveyScores, String>(
                          dataSource: ss,
                          xValueMapper: (SurveyScores data, _) => data.date,
                          yValueMapper: (SurveyScores data, _) => data.score,
                          markerSettings: MarkerSettings(
                            isVisible: true,
                            color: Colors.blueAccent,
                          ),
                            dataLabelSettings: DataLabelSettings(
                                isVisible: true,
                                color: Colors.transparent
                            )
                        ),
                      ],
                    )
                ),
              ],
            ),
          ),
        ),
        onWillPop: () {
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(
            builder: (_) => GraphSurvey(ss, score),
          ));
          return falsing();
        },
      );
    },
  );

}
}

class SurveyScores {
  SurveyScores(this.date, this.score);
  final String date;
  final int score;
}
