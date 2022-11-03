import 'package:emshealth/notification_api.dart';
import 'package:emshealth/graph_survey.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo_dart;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'database.dart';

/// Completion page that is shown when the user submits the survey.
class CompletionPage extends StatefulWidget {
  final Map<String, dynamic> scoreData;
  final String name;
  final Map<String, String> quizResult;
  const CompletionPage(
      {Key? key,
      required this.scoreData,
      required this.name,
      required this.quizResult})
      : super(key: key);

  @override
  State<CompletionPage> createState() => _CompletionPageState();
}

/// Completion page state.
class _CompletionPageState extends State<CompletionPage> {
  List<SurveyScores> ss = [];

  /// Updates local and remote databases.
  Future<void> updateDatabase() async {
    int score = widget.scoreData["score"]!;
    DateTime dateNow = DateTime.now();

    String dateToAdd = '${dateNow.month}/${dateNow.day}/${dateNow.year}';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? dates = prefs.getStringList("dates");
    List<String>? scores = prefs.getStringList("scores");
    if (!(dates != null &&
        dates.isNotEmpty &&
        scores != null &&
        scores.isNotEmpty)) {
      dates = [];
      scores = [];
    }
    dates.add(dateToAdd);
    scores.add(score.toString());

    for (int i = 0; i < dates.length; i++) {
      ss.add(SurveyScores(dates[i], int.parse(scores[i])));
    }

    prefs.setInt("scoreToday", score);
    prefs.setString('date', time);
    prefs.setStringList("dates", dates);
    prefs.setStringList("scores", scores);

    // UPDATE DATABASE HERE
    Map<String, dynamic> user = await MongoDB.findUser(widget.name);
    mongo_dart.ObjectId userId = user['_id'];

    widget.scoreData["date"] = '$dateNow';
    widget.scoreData["name"] = widget.name;
    mongo_dart.ObjectId surveyId =
        await MongoDB.addSurvey(widget.scoreData, userId);

    widget.quizResult["date"] = '$dateNow';
    await MongoDB.addRawSurvey(widget.quizResult, surveyId, userId);

    // schedule notifications
    await schedule24HoursAheadAN();
  }

  @override
  Widget build(BuildContext context) {
    int score = widget.scoreData["score"]!;
    final String needs = widget.scoreData["needs"];

    Future<bool> falsing() async {
      return false;
    }

    return FutureBuilder(
      future: updateDatabase(),
      builder: (context, snapshot) {
        Size size = MediaQuery.of(context).size;

        return WillPopScope(
          child: Scaffold(
            backgroundColor: const Color(0xff0b3954),
            appBar: AppBar(
              centerTitle: true,
              title: const Text(
                'Great Job!',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontFamily: "OpenSans"),
              ),
              backgroundColor: const Color(0xff0b3954),
              elevation: 0,
              leading: null,
            ),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    child: Container(
                      height: 40,
                      width: size.width * 0.6,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: const Color(0xff087e8b),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 10),
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 10,
                            ),
                          ]),
                      child: const Text(
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => GraphSurvey(
                                gSS: ss, scoreToday: score, name: widget.name),
                          ));
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: 150,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text(
                                "Your score today: ",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "OpenSans",
                                    color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: (score >= 0 && score <= 20)
                                        ? Colors.green
                                        : ((score >= 25 && score <= 35
                                            ? Colors.yellow
                                            : Colors.red)),
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "$score",
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "OpenSans"),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text(
                                "Your needs today: ",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "OpenSans",
                                    color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Container(
                                  height: 50,
                                  alignment: Alignment.center,
                                  child: Text(
                                    needs,
                                    style: const TextStyle(
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
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      alignment: Alignment.center,
                      child: const Text(
                        "Your next survey will be at 8am tomorrow.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: "OpenSans",
                            color: Colors.white),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "Your past 5 records: ",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: "OpenSans",
                          color: Colors.white),
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
                            labelStyle: const TextStyle(
                              fontFamily: "OpenSans",
                              color: Colors.white,
                            ),
                            majorGridLines: const MajorGridLines(
                                color: Colors.transparent)),
                        primaryYAxis: CategoryAxis(
                          borderColor: Colors.transparent,
                          labelStyle: const TextStyle(
                            fontFamily: "OpenSans",
                            color: Colors.white,
                          ),
                          majorGridLines:
                              const MajorGridLines(color: Colors.transparent),
                          isInversed: true,
                        ),
                        series: <ChartSeries>[
                          LineSeries<SurveyScores, String>(
                              dataSource: ss,
                              xValueMapper: (SurveyScores data, _) => data.date,
                              yValueMapper: (SurveyScores data, _) =>
                                  data.score,
                              markerSettings: const MarkerSettings(
                                isVisible: true,
                                color: Colors.blueAccent,
                              ),
                              dataLabelSettings: const DataLabelSettings(
                                  isVisible: true, color: Colors.transparent)),
                        ],
                      )),
                ],
              ),
            ),
          ),
          onWillPop: () {
            Navigator.popUntil(context, (route) => route.isFirst);
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => GraphSurvey(
                      gSS: ss, scoreToday: score, name: widget.name),
                ));
            return falsing();
          },
        );
      },
    );
  }
}

/// Survey score model.
class SurveyScores {
  SurveyScores(this.date, this.score);
  final String date;
  final int score;
}
