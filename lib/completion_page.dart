import 'package:emshealth/home_page.dart';
import 'package:emshealth/home_page2.dart';
import 'package:emshealth/notification_api.dart';
import 'package:emshealth/survey_data.dart';
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
List<SurveyScores> ss1 = [];

Future<void> updateDatabase() async {

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String time = DateTime.now().year.toString() + ' ' + DateTime.now().month.toString() + ' ' + DateTime.now().day.toString();

  if (prefs.getString('date').toString().compareTo(time) == 0) return;

  prefs.setString('date', time);

  CollectionReference patients = FirebaseFirestore.instance.collection('patients');

  QuerySnapshot query = await patients.where('name', isEqualTo: '$name').get();
  QueryDocumentSnapshot doc = query.docs[0];
  DocumentReference docRef = doc.reference;

  int priority = (score >= 0 && score <= 20) ? 3 : ((score >= 25 && score <= 35 ? 2 : 1 ));

  docRef.update({'priority': priority});

  DocumentSnapshot docSnap = await docRef.get();
  var docId = docSnap.reference.id;
  CollectionReference surveys = FirebaseFirestore.instance.collection('patients/$docId/surveys');
  //give an id to the survey
  var xid = Xid();
  String surveyId = xid.toString();
  List<String> dates = [];
  List<int> scores = [];

  //get the past 5 records
  QuerySnapshot queryRecords = await surveys.orderBy('date', descending: true).limit(5).get();
  print(queryRecords);
  List<dynamic> recordList = queryRecords.docs;
  for (var record in recordList) {
    QueryDocumentSnapshot doc = record;
    DocumentReference docRecord = doc.reference;
    DocumentSnapshot docRecSnap = await docRecord.get();
    var rec = docRecSnap.data();

    //parse record
    String recStr = rec.toString();
    int idx = recStr.indexOf('score:');
    recStr = recStr.substring(idx + 7);
    idx = recStr.indexOf(',');
    recStr = recStr.substring(0, idx);
    scores.add(int.parse(recStr));

    //parse record
    String recStrDate = rec.toString();
    idx = recStrDate.indexOf('date: ');
    recStrDate = recStrDate.substring(idx + 6);
    idx = recStrDate.indexOf(',');
    recStrDate = recStrDate.substring(0, idx);
    //recStrDate = recStrDate.substring(0, 10);
    dates.add(recStrDate);
  }

  List<String> conds = quizResult[questions[7]].toString().split('+').toList();
  print("x:  $conds");
  conds.removeLast();

  await surveys.add({
    'date': DateTime.now().toString(),
    'surveyId': surveyId,
    'score': score,
    'needs': needs,
    'breathing': quizResult[questions[0]].toString(),
    'breathing_compare': quizResult[questions[1]].toString(),
    'heart': quizResult[questions[2]].toString(),
    'sleep': quizResult[questions[3]].toString(),
    'sleep_compare': quizResult[questions[4]].toString(),
    'weight': quizResult[questions[5]].toString(),
    'weight_compare': quizResult[questions[6]].toString(),
    'condition': conds,
    'energy_levels': quizResult[questions[8]].toString(),
  });

  print('success send update');

  //parse into graphs
  for (int i = dates.length - 1; i >= 0; i--) {
    ss.add(new SurveyScores(dates[i], scores[i]));
    print('${dates[i]}, ${scores[i]}');
  }

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
      print("Cancelling...");
      cancelScheduledNotifications();
      NotificationWeekAndTime? nw = NotificationWeekAndTime(dayOfTheWeek: dt.day + 1, timeOfDay: TimeOfDay.fromDateTime(DateTime(
        dt.year, dt.month, dt.day + 1, 8, 0, 0, 0, 0
      )));

      /*
      * for testing, uncomment this part:-
      * NotificationWeekAndTime? nw = NotificationWeekAndTime(dayOfTheWeek: dt.day, timeOfDay: TimeOfDay.fromDateTime(DateTime(
        dt.year, dt.month, dt.day, dt.hour + 1, 0, 0, 0, 0
      )));
      * */
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
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(
                  builder: (_) => HomePage2(),
                ));
              },
            ),
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
                      /*Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HomePage2(),
                      ),
                          (route) => route.isFirst,
                    );*/
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(
                        builder: (_) => HomePage2(),
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
                      ),
                      primaryYAxis: CategoryAxis(
                        borderColor: Colors.transparent,
                        labelStyle: TextStyle(
                          fontFamily: "OpenSans",
                          color: Colors.white,
                        ),
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
            builder: (_) => HomePage2(),
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