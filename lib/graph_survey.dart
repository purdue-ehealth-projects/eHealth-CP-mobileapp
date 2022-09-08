import 'package:emshealth/completion_page.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GraphSurvey extends StatelessWidget {

  final List<SurveyScores> gSS;
  final int scoreToday;

  GraphSurvey(this.gSS, this.scoreToday);

  @override
  Widget build(BuildContext context) {
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
          leading: null,
        ),
        body:Container(
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  "Your Score Today",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "OpenSans",
                    fontWeight: FontWeight.w700,
                    fontSize: 40,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: (scoreToday >= 0 && scoreToday <= 20) ? Colors.green : ((scoreToday >= 25 && scoreToday <= 35 ? Colors.yellow : Colors.red )),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "$scoreToday",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontFamily: "OpenSans"
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                "You did your survey today! See you tomorrow!",
                style: TextStyle(
                  fontFamily: "OpenSans",
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
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
                          dataSource: gSS,
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
    );
  }
}