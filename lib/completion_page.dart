import 'package:emshealth/notification_api.dart';
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
const CompletionPage({Key? key, required this.score, required this.needs, required this.name, required this.quizResult}) : super(key: key);

@override
Widget build(BuildContext context) {

  DateTime dt = DateTime.now();
  NotificationWeekAndTime? nw = NotificationWeekAndTime(dayOfTheWeek: (dt.day) + 1, timeOfDay: TimeOfDay.fromDateTime(DateTime(
      dt.year, dt.month, dt.day + 1, 8, 0, 0, 0, 0
  )));
  createDailyReminder(nw);

  Future<void> updateDatabase() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    CollectionReference surveys = FirebaseFirestore.instance.collection('surveys');

    QuerySnapshot query = await users.where('name', isEqualTo: '$name').get();
    QueryDocumentSnapshot doc = query.docs[0];
    DocumentReference docRef = doc.reference;

    var user = doc.data();

    //give an id to the survey
    var xid = Xid();
    String surveyId = xid.toString();

    print(user);
    List<String> surveyIds = [];
    if (user.toString().contains('surveyId')) {
      //parse data
      int idx = user.toString().indexOf("surveyId: ");
      String data = user.toString().substring(idx + 11);
      idx = data.indexOf(']');
      data = data.substring(0, idx);
      print(data);
      List<String> temp = data.split(', ');
      for (String t in temp) {
        surveyIds.add(surveyId);
      }
      surveyIds.add(surveyId);
    } else {
      surveyIds.add(surveyId);
    }

    await docRef.update({'surveyId': FieldValue.arrayUnion(surveyIds)});

    await surveys.add({
      'name': '$name',
      'date': DateTime.now().toString(),
      'surveyId': surveyId,
      'score': score,
      'needs': needs,
      'breathing': quizResult[1][0],
      'breathing-compare': quizResult[2][0],
      'heart': quizResult[3][0],
      'sleep': quizResult[4][0],
      'sleep-compare': quizResult[5][0],
      'weight': quizResult[6][0],
      'weight-compare': quizResult[7][0],
      'condition': quizResult[8],
      'energy-level': quizResult[9][0],
    });

    print('success');
  }

  return FutureBuilder(
    future: updateDatabase(),
    builder: (context, snapshot) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Completion'),
        ),
        body: Column(
          children: <Widget>[
            Text("Your score today: $score"),
            Text("Your needs today: $needs"),
            Text("Your next survey will be at 8am tomorrow."),
          ],
        ),
      );
    },
  );

}
}