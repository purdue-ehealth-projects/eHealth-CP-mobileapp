import 'package:emshealth/completion_page.dart';
import 'package:emshealth/survey_data.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

LinearPercentIndicator getProgressBar(int percent, BuildContext context) {
  return LinearPercentIndicator(
    alignment: MainAxisAlignment.center,
    width: MediaQuery.of(context).size.width - MediaQuery.of(context).size.width *  0.6,
    center: Text(percent.toString() + "%",style: const TextStyle( color: Colors.grey)),
    lineHeight: 25.0,
    percent: (percent / 100).toDouble(),
    //linearStrokeCap: LinearStrokeCap.roundAll,
    linearStrokeCap: LinearStrokeCap.roundAll,
    backgroundColor: Colors.white,
    barRadius: const Radius.circular(16),
    progressColor: Color(0xff00587A),
    animation: true,
    animationDuration: 2000,

  );
}

GestureDetector optionBuilder(List<String> choices, int index, int selectedIdx, Function setIdx) {
  return GestureDetector(
      child: Container(
        width: 250,
        height: 50,
        alignment: Alignment.center,
        child: Text(
            choices[index],
          textAlign: TextAlign.center,
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15)),
            border: Border.all(
              style: BorderStyle.solid,
              width: 3,
              color: (selectedIdx == index) ? Colors.blue : Colors.black,
            )
        ),
      ),
      onTap: () {
        setIdx(index);
      }
  );
}

class SurveyWelcomePage extends StatefulWidget {
  final String username;
  const SurveyWelcomePage({Key? key, required this.username}) : super(key: key);

  @override
  _SurveyWelcomePageState createState() => _SurveyWelcomePageState(this.username);
}

class _SurveyWelcomePageState extends State<SurveyWelcomePage> {

  final String username;

  _SurveyWelcomePageState(this.username);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: getProgressBar(0, context),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Text(
                "Welcome to the survey! \nThis will only take 5 minutes.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 70),
            GestureDetector(
              child: Container(
                width: 150,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: Colors.blue,
                ),
                alignment: Alignment.center,
                child: Text(
                  "Next",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SurveyQues1(username: this.username, choices: choices1, question: 0, percent: 0.toInt()),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}


class SurveyQues1 extends StatefulWidget {

  final List<String> choices;
  final int question;
  final int percent;
  final String username;

  const SurveyQues1({Key? key, required this.choices, required this.question, required this.percent, required this.username}) : super(key: key);

  @override
  _SurveyQues1State createState() => _SurveyQues1State(this.username, this.choices, this.question, this.percent);
}

Map<String, String> x = new Map();
int score = 0;

class _SurveyQues1State extends State<SurveyQues1> {

  final String username;
  final List<String> choices;
  final int question;
  final int percent;

  int selectedIdx = 0;

  _SurveyQues1State(this.username, this.choices, this.question, this.percent);

  void setIdx(int idx) {
    setState(() {
      selectedIdx = idx;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: getProgressBar(percent, context),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Text(
                questions[question],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 70),
            optionBuilder(choices, 0, selectedIdx, setIdx),
            SizedBox(height: 10),
            optionBuilder(choices, 1, selectedIdx, setIdx),
            SizedBox(height: 10),
            optionBuilder(choices, 2, selectedIdx, setIdx),
            SizedBox(height: 10),
            (choices.length > 3) ? optionBuilder(choices, 3, selectedIdx, setIdx) : Container(),
            (choices.length > 3) ? SizedBox(height: 10) : Container(),
            (choices.length > 4) ? optionBuilder(choices, 4, selectedIdx, setIdx) : Container(),
            (choices.length > 4) ? SizedBox(height: 10) : Container(),
            GestureDetector(
              child: Container(
                width: 150,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: Colors.blue,
                ),
                alignment: Alignment.center,
                child: Text(
                  "Next",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              onTap: () {
                print("question: $question");
                if (question == 8) {
                  print("hey");
                  print(x);
                  /*
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CompletionPage(name: username, score: 0, quizResult: [], needs: choices[selectedIdx]),
                    ),
                  );*/
                } else if (question == 6 ) {
                  if (x.containsKey(questions[question])) {
                    x.update(questions[question], (value) => choices[selectedIdx]);
                  } else {
                    x.putIfAbsent(questions[question], () => choices[selectedIdx]);
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SurveyQues2(username: username, choices: choices7, question: question + 1, percent: this.percent + 10),
                    ),
                  );

                } else {
                  if (x.containsKey(questions[question])) {
                    x.update(questions[question], (value) => choices[selectedIdx]);
                  } else {
                    x.putIfAbsent(questions[question], () => choices[selectedIdx]);
                  }
                  List<String> temp = [];
                  switch(question) {
                    case 0:
                      temp = choices2;
                      break;
                    case 1:  //2
                      temp = choices3;
                      break;
                    case 2:
                      temp = choices4;
                      break;
                    case 3:  //2
                      temp = choices2;
                      break;
                    case 4:
                      temp = choices5;
                      break;
                    case 5:  //2
                      temp = choices6;
                      break;
                    case 6:
                      temp = choices7;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SurveyQues2(username: username, choices: temp, question: question + 1, percent: this.percent + 10),
                        ),
                      );
                      break;
                    case 7:  //2
                      temp = choices2;
                      break;
                    case 8:
                      temp = choices8;
                      break;
                  }


                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SurveyQues1(username: username, choices: temp, question: question + 1, percent: this.percent + 10),
                    ),
                  );
                }

              },
            )
          ],
        ),
      ),
    );
  }


}

class SurveyQues2 extends StatefulWidget {
  final String username;
  final List<String> choices;
  final int question;
  final int percent;

  const SurveyQues2({Key? key, required this.username, required this.choices, required this.question, required this.percent}) : super(key: key);

  @override
  _SurveyQues2State createState() => _SurveyQues2State(this.username, this.choices, this.question, this.percent);

}

GestureDetector optionBuilder2(List<String> choices, int index, List pressL, Function setIdx) {
  return GestureDetector(
      child: Container(
        width: 250,
        height: 50,
        alignment: Alignment.center,
        child: Text(
          choices[index],
          textAlign: TextAlign.center,
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15)),
            border: Border.all(
              style: BorderStyle.solid,
              width: 3,
              color: (pressL[index]) ? Colors.blue : Colors.black,
            )
        ),
      ),
      onTap: () {
        setIdx(index, pressL);
      }
  );
}

class _SurveyQues2State extends State<SurveyQues2> {

  final String username;
  final List<String> choices;
  final int question;
  final int percent;


  List pressL = [false, false, false, false, false];

  _SurveyQues2State(this.username, this.choices, this.question, this.percent);

  void setIdx2(int idx, List pressL) {
    setState(() {
      print(idx);
      pressL[idx] = !pressL[idx];
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Am i hereeeee");
    return Scaffold(
      appBar: AppBar(
        title: getProgressBar(percent, context),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Text(
                questions[question],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 70),
            optionBuilder2(choices7, 0, pressL, setIdx2),
            SizedBox(height: 10),
            optionBuilder2(choices7, 1, pressL, setIdx2),
            SizedBox(height: 10),
            optionBuilder2(choices7, 2, pressL, setIdx2),
            SizedBox(height: 10),
            optionBuilder2(choices7, 3, pressL, setIdx2),
            SizedBox(height: 10),
            optionBuilder2(choices7, 4, pressL, setIdx2),
            SizedBox(height: 10),
            GestureDetector(
              child: Container(
                width: 150,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: Colors.blue,
                ),
                alignment: Alignment.center,
                child: Text(
                  "Next",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              onTap: () {
                String temp = '';
                for (int i = 0; i < pressL.length; i++) {
                  if (pressL[i]) {
                    temp += choices7[i];
                    temp += "+";
                  }
                }
                if (x.containsKey(questions[question])) {
                  x.update(questions[question], (value) => temp);
                } else {
                  x.putIfAbsent(questions[question], () => temp);
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SurveyQues1(username: username, choices: choices2, question: question + 1, percent: this.percent + 10),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

}

