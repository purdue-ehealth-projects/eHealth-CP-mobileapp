import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:restart_app/restart_app.dart';

import 'widgets.dart';
import 'home_page.dart';

class GraphSurvey extends StatefulWidget {
  final List<SurveyScores> gSS;
  final int scoreToday;
  final String name;
  final String needs;
  const GraphSurvey(
      {Key? key,
      required this.gSS,
      required this.scoreToday,
      required this.name,
      required this.needs})
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
    final String needs = widget.needs;
    Scaffold scaffold = Scaffold(
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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        //alignment: Alignment.center,
        child: Column(
          children: <Widget>[
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
            const SizedBox(height: 10),
            const Text(
              "Great job today!\nYour next survey will be at 8 AM tomorrow.",
              style: TextStyle(
                fontFamily: "OpenSans",
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20),
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
              ),
            ),
          ],
        ),
      ),
    );
    return FGBGNotifier(
      onEvent: (event) {
        // FGBGType.foreground or FGBGType.background
        if (event == FGBGType.foreground) {
          Restart.restartApp();
        }
      },
      child: scaffold,
    );
  }
}
