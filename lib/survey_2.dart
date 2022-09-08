import 'package:emshealth/completion_page.dart';
import 'package:emshealth/survey_data.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

LinearPercentIndicator getProgressBar(int percent, BuildContext context) {
  return LinearPercentIndicator(
    alignment: MainAxisAlignment.center,
    width: MediaQuery.of(context).size.width - MediaQuery.of(context).size.width *  0.4,
    center: Text(percent.toString() + "%",style: const TextStyle( color: Colors.black)),
    lineHeight: 25.0,
    percent: (percent / 100).toDouble(),
    //linearStrokeCap: LinearStrokeCap.roundAll,
    linearStrokeCap: LinearStrokeCap.roundAll,
    backgroundColor: Colors.white,
    barRadius: const Radius.circular(10),
    progressColor: Color(0xff0b3954).withOpacity(0.5),
    animation: true,
    animationDuration: 500,

  );
}

GestureDetector optionBuilder(List<String> choices, int index, int selectedIdx, Function setIdx, Size size) {
  return GestureDetector(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 7.5),
        child: Container(
          width: size.width * 0.9,
          height: 80,
          alignment: Alignment.center,
          child: Text(
            choices[index],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'OpenSans',
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              border: Border.all(
                style: BorderStyle.solid,
                width: 3,
                color: (selectedIdx == index) ? Colors.blue : Colors.transparent,
              )
          ),
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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xff0b3954),
      appBar: AppBar(
        backgroundColor: Color(0xff0b3954),
        actions: <Widget>[getProgressBar(0, context)],
      ),
      body: ListView(
          children: <Widget>[
            Container(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40, horizontal: 10),
                child: Container(
                  height: size.height * 0.5,
                  child: Text(
                    "Welcome to the survey! \nThis will only take 5 minutes.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                        color: Colors.white
                    ),
                  ),
                ),
              ),
            ),
              GestureDetector(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 7.5),
                  child: Container(
                    width: size.width * 0.8,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Next",
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
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
              ),
          ],
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

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0b3954),
        actions: <Widget>[getProgressBar(percent, context)],
      ),
      body: Container(
        color: Color(0xff0b3954),
        alignment: Alignment.center,
        child: Stack(
          children: <Widget>[
            ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 30, bottom: 10, left: 10, right: 10),
                  child: Container(
                    child: Text(
                      questions[question],
                      style: TextStyle(
                        fontFamily: "OpenSans",
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                optionBuilder(choices, 0, selectedIdx, setIdx, size),
                SizedBox(height: 10),
                optionBuilder(choices, 1, selectedIdx, setIdx, size),
                SizedBox(height: 10),
                optionBuilder(choices, 2, selectedIdx, setIdx, size),
                SizedBox(height: 10),
                (choices.length > 3) ? optionBuilder(choices, 3, selectedIdx, setIdx, size) : Container(),
                (choices.length > 3) ? SizedBox(height: 10) : Container(),
                (choices.length > 4) ? optionBuilder(choices, 4, selectedIdx, setIdx, size) : Container(),
                (choices.length > 4) ? SizedBox(height: 10) : Container(),
          ],
        ),
            Positioned(
              bottom: 70,
              left: 80,
              child: GestureDetector(
                child: Container(
                  width: size.width * 0.6,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Next",
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                onTap: () {
                  if (x.containsKey(questions[question])) {
                    x.update(questions[question], (value) => choices[selectedIdx]);
                  } else {
                    x.putIfAbsent(questions[question], () => choices[selectedIdx]);
                  }

                  if (question == 9) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LastSurveyPage(username: username, percent: this.percent + 10),
                      ),
                    );
                  } else if (question == 6 ) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SurveyQues2(username: username, choices: choices7, question: question + 1, percent: this.percent + 10),
                      ),
                    );
                  } else {
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
            ),
          ],
        ),
      ),
    );
  }
}

GestureDetector optionBuilder2(List<String> choices, int index, List pressL, Function setIdx, Size size) {
  return GestureDetector(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 7.5),
        child: Container(
          width: size.width * 0.9,
          height: 80,
          alignment: Alignment.center,
          child: Text(
            choices[index],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'OpenSans',
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              border: Border.all(
                style: BorderStyle.solid,
                width: 3,
                color: (pressL[index]) ? Colors.blue : Colors.transparent,
              )
          ),
        ),
      ),
      onTap: () {
        setIdx(index, pressL);
      }
  );
}

int collectScore(Map<String, String> x) {
  int score = 0;
  for (String q in questions) {
    String temp = x[q].toString();

    if (q.compareTo('I have: \nChoose all that apply.') == 0) {
      List<String> list = temp.split('+');
      score += list.length * 5;
      continue;
    }

    if (q.compareTo("Energy level: \nChoose one option.") == 0) {
      if (temp.compareTo("Better than yesterday") == 0) score -= 5;
      if (temp.compareTo("Same as yesterday") == 0) score += 0;
      if (temp.compareTo("Worse than yesterday") == 0) score += 5;
      continue;
    }

    if (temp.compareTo("I am breathing well") == 0) score += 0;
    if (temp.compareTo("I run out of breath when walking") == 0) score += 5;
    if (temp.compareTo("I run out of breath when talking") == 0) score += 10;

    if (temp.compareTo("I feel great") == 0) score += 0;
    if (temp.compareTo("My heart is racing") == 0) score += 5;
    if (temp.compareTo("I have chest pain") == 0) score += 10;

    if (temp.compareTo("I slept well last night") == 0) score += 0;
    if (temp.compareTo("My sleep was restless") == 0) score += 5;
    if (temp.compareTo("I had to use pillows to sit up in bed") == 0) score += 10;

    if (temp.compareTo("My weight went up 2 or more pounds since yesterday") == 0) score += 10;
    if (temp.compareTo("My clothes and shoes feel tight") == 0) score += 5;
    if (temp.compareTo("I can see swelling in my ankles") == 0) score += 5;
    if (temp.compareTo("My weight is the same or less than yesterday") == 0) score += 0;

    if (temp.compareTo("I slept well last night") == 0) score += 0;
    if (temp.compareTo("My sleep was restless") == 0) score += 5;
    if (temp.compareTo("I had to use pillows to sit up in bed") == 0) score += 10;

  }

  return score;
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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0b3954),
        actions: <Widget>[getProgressBar(percent, context)],
      ),
      body: Container(
        color: Color(0xff0b3954),
        alignment: Alignment.center,
        child: Stack(
          children: <Widget>[
            ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 30, bottom: 10, left: 10, right: 10),
                  child: Container(
                    child: Text(
                      questions[question],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "OpenSans",
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                optionBuilder2(choices7, 0, pressL, setIdx2, size),
                SizedBox(height: 10),
                optionBuilder2(choices7, 1, pressL, setIdx2, size),
                SizedBox(height: 10),
                optionBuilder2(choices7, 2, pressL, setIdx2, size),
                SizedBox(height: 10),
                optionBuilder2(choices7, 3, pressL, setIdx2, size),
                SizedBox(height: 10),
                optionBuilder2(choices7, 4, pressL, setIdx2, size),
                SizedBox(height: 10),
          ],
        ),
            Positioned(
                bottom: 70,
                left: 80,
              child: GestureDetector(
                child: Container(
                  width: size.width * 0.6,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Next",
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      color: Colors.white,
                      fontSize: 24,
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
            ),
          ],
        ),
      ),
    );
  }

}

class LastSurveyPage extends StatefulWidget {
  final String username;
  final int percent;

  const LastSurveyPage({Key? key, required this.username, required this.percent}) : super(key: key);

  @override
  _LastSurveyPage createState() => _LastSurveyPage(this.username, this.percent);

}

class _LastSurveyPage extends State<LastSurveyPage> {

  final String username;
  final int percent;

  _LastSurveyPage(this.username, this.percent);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0b3954),
        actions: <Widget>[getProgressBar(percent, context)],
      ),
      body: Container(
        color: Color(0xff0b3954),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 40, horizontal: 10),
              child: Container(
                child: Text(
                  "Are you ready to submit?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      color: Colors.white
                  ),
                ),
              ),
            ),
            SizedBox(height: 300),
            GestureDetector(
              child: Container(
                width: size.width * 0.8,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Submit",
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              onTap: () {
                print(x);
                int scoreQ = collectScore(x);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CompletionPage(name: username, score: scoreQ, quizResult: x, needs: x[questions[9]].toString()),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

}

