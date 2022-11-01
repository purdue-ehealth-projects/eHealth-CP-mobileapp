import 'package:emshealth/completion_page.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'home_page.dart';

TextButton profileButton(BuildContext context, String username) {
  return TextButton(
    onPressed: () => showProfile(context, username),
    style: TextButton.styleFrom(
      foregroundColor: Colors.white,
    ),
    child: const Icon(Icons.account_circle),
  );
}

class GraphSurvey extends StatefulWidget {
  final List<SurveyScores> gSS;
  final int scoreToday;
  final String name;
  const GraphSurvey(
      {Key? key,
      required this.gSS,
      required this.scoreToday,
      required this.name})
      : super(key: key);

  @override
  State<GraphSurvey> createState() => _GraphSurveyState();
}

class _GraphSurveyState extends State<GraphSurvey> {
  @override
  Widget build(BuildContext context) {
    final List<SurveyScores> gSS = widget.gSS;
    final int scoreToday = widget.scoreToday;
    final String name = widget.name;
    return Scaffold(
      backgroundColor: const Color(0xff0b3954),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "EMS Health Home Page",
          style: TextStyle(fontFamily: "OpenSans"),
        ),
        backgroundColor: const Color(0xff0b3954),
        leading: null,
        actions: <Widget>[profileButton(context, name)],
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                "Your Score Today:",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: "OpenSans",
                    fontWeight: FontWeight.w700,
                    fontSize: 35,
                    color: Colors.white,
                    overflow: TextOverflow.ellipsis),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: (scoreToday >= 0 && scoreToday <= 20)
                      ? Colors.green
                      : ((scoreToday >= 25 && scoreToday <= 35
                          ? Colors.yellow
                          : Colors.red)),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  "$scoreToday",
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontFamily: "OpenSans"),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "You did your survey today! See you tomorrow!",
              style: TextStyle(
                fontFamily: "OpenSans",
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                "Your past 5 records: ",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: "OpenSans",
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
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
                      majorGridLines:
                          const MajorGridLines(color: Colors.transparent)),
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
                        dataSource: gSS,
                        xValueMapper: (SurveyScores data, _) => data.date,
                        yValueMapper: (SurveyScores data, _) => data.score,
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
    );
  }
}
