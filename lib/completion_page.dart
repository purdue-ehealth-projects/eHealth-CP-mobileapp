import 'package:emshealth/home_page.dart';
import 'package:emshealth/notification_api.dart';
import 'package:fl_chart/fl_chart.dart';
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
final List<List<String>> quizResult;
CompletionPage({Key? key, required this.score, required this.needs, required this.name, required this.quizResult}) : super(key: key);
List<SurveyScores> ss = [];

@override
Widget build(BuildContext context) {

  DateTime dt = DateTime.now();
  NotificationWeekAndTime? nw = NotificationWeekAndTime(dayOfTheWeek: (dt.day) + 1, timeOfDay: TimeOfDay.fromDateTime(DateTime(
      dt.year, dt.month, dt.day + 1, 8, 0, 0, 0, 0
  )));
  createDailyReminder(nw);

  Future<void> updateDatabase() async {
    CollectionReference patients = FirebaseFirestore.instance.collection('patients');
    //CollectionReference surveys = FirebaseFirestore.instance.collection('surveys');

    QuerySnapshot query = await patients.where('name', isEqualTo: '$name').get();
    QueryDocumentSnapshot doc = query.docs[0];
    DocumentReference docRef = doc.reference;
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

    await surveys.add({
      'date': DateTime.now().toString(),
      'surveyId': surveyId,
      'score': score,
      'needs': needs,
      'breathing': quizResult[1][0],
      'breathing_compare': quizResult[2][0],
      'heart': quizResult[3][0],
      'sleep': quizResult[4][0],
      'sleep_compare': quizResult[5][0],
      'weight': quizResult[6][0],
      'weight_compare': quizResult[7][0],
      'condition': quizResult[8],
      'energy_levels': quizResult[9][0],
    });

    print('success');

    //parse into graphs
    for (int i = 0; i < dates.length; i++) {
      ss.add(new SurveyScores(dates[i], scores[i]));
      print('${dates[i]}, ${scores[i]}');
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String time = DateTime.now().year.toString() + ' ' + DateTime.now().month.toString() + ' ' + DateTime.now().day.toString();
    prefs.setString('date', time);

  }

  return FutureBuilder(
    future: updateDatabase(),
    builder: (context, snapshot) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Great Job!'),
          backgroundColor: Color(0xff0b3954),
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                  builder: (_) => HomePage(),
                  ),
              );
            }
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              Container(
                child: ElevatedButton(
                  child: Text("Go back to Home Page"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HomePage(),
                      ),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    foregroundColor: MaterialStateProperty.all(Colors.black87),
                    shadowColor: MaterialStateProperty.all(Color(0xff0b3954)),
                  ),
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
                              ),
                            textAlign: TextAlign.center,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Container(
                              height: 50,
                              width: 50,
                              alignment: Alignment.center,
                              child: Text(
                                "$needs",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
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
                  child: Text(
                    "Your next survey will be at 8am tomorrow.",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
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
                    ),
                  ),
                ),
              ),
              Container(
                  padding: const EdgeInsets.all(5),
                  height: 400,
                  width: double.infinity,
                  child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(
                      labelRotation: 90,
                      autoScrollingMode: AutoScrollingMode.start,
                    ),
                    series: <ChartSeries>[
                      LineSeries<SurveyScores, String>(
                        dataSource: ss,
                        xValueMapper: (SurveyScores data, _) => data.date,
                        yValueMapper: (SurveyScores data, _) => data.score,
                      ),
                    ],
                  )
              ),
            ],
          ),
        ),
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