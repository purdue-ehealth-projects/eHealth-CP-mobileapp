import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo_dart;
import 'package:loading_indicator/loading_indicator.dart';
import 'package:restart_app/restart_app.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

import 'home_page.dart';
import 'survey_data.dart';
import 'graph_survey.dart';
import 'database.dart';
import 'notification_api.dart';
import 'alerts.dart';
import 'buttons.dart';

/// Returns a progress bar given the percent and context.
LinearPercentIndicator getProgressBar(int percent, BuildContext context) {
  return LinearPercentIndicator(
    alignment: MainAxisAlignment.center,
    width: MediaQuery.of(context).size.width -
        MediaQuery.of(context).size.width * 0.4,
    center: Text("$percent%", style: const TextStyle(color: Colors.black)),
    lineHeight: 25.0,
    percent: (percent / 100).toDouble(),
    backgroundColor: Colors.white,
    barRadius: const Radius.circular(10),
    progressColor: const Color(0xff0b3954).withOpacity(0.5),
    animation: true,
    animationDuration: 500,
  );
}

/// Maps user answer to each question.
final Map<String, String> _quizResult = {};
const double _nextFontSize = 32;

/// Welcome page.
class SurveyWelcomePage extends StatefulWidget {
  final String name;
  const SurveyWelcomePage({Key? key, required this.name}) : super(key: key);

  @override
  State<SurveyWelcomePage> createState() => _SurveyWelcomePageState();
}

/// Welcome page state.
class _SurveyWelcomePageState extends State<SurveyWelcomePage> {
  @override
  Widget build(BuildContext context) {
    final String name = widget.name;
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xff0b3954),
      appBar: AppBar(
        backgroundColor: const Color(0xff0b3954),
        actions: <Widget>[
          getProgressBar(0, context),
          profileButton(context, name),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Hello, $name",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 36, // Increased font size for a welcoming effect
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20), // Added some vertical spacing
              const Text(
                "Welcome to the survey!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20), // Added more vertical spacing
              const Text(
                "This will only take 5 minutes.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 18, // Smaller font size for additional information
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GestureDetector(
          child: Container(
            width: size.width * 0.8,
            height: 60, // Reduced button height
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30), // Rounded button corners
              color: Colors.blue, // Changed button color
            ),
            alignment: Alignment.center,
            child: const Text(
              "Start",
              style: TextStyle(
                fontFamily: 'OpenSans',
                color: Colors.white,
                fontSize: 24, // Larger font size for the button text
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SurveyQuestions(
                  name: name,
                  choices: choicesData[0], // Replace with actual data
                  question: 0,
                  percent: 0, // Replace with actual percentage
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Survey page for single select questions.
class SurveyQuestions extends StatefulWidget {
  final List<String> choices;
  final int question;
  final int percent;
  final String name;

  const SurveyQuestions({
    Key? key,
    required this.choices,
    required this.question,
    required this.percent,
    required this.name,
  }) : super(key: key);

  @override
  State<SurveyQuestions> createState() => _SurveyQuestionsState();
}

/// Survey question page state.
class _SurveyQuestionsState extends State<SurveyQuestions> {
  String? selectedVal;
  double itemHeight = 0;

  @override
  Widget build(BuildContext context) {
    final String name = widget.name;
    final int question = widget.question;
    final List<String> choices = widget.choices;
    final int percent = widget.percent;

    final Size size = MediaQuery.of(context).size;
    itemHeight = size.height / 10;
    return Scaffold(
      backgroundColor: const Color(0xff0b3954),
      appBar: AppBar(
        backgroundColor: const Color(0xff0b3954),
        actions: <Widget>[
          getProgressBar(percent, context),
          profileButton(context, name),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                questions[question],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Column(
                children: choices.map((item) {
                  return RadioListTile<String>(
                    title: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    value: item,
                    groupValue: selectedVal,
                    onChanged: (value) {
                      setState(() {
                        selectedVal = value;
                      });
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GestureDetector(
          child: Container(
            width: size.width * 0.8,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: selectedVal == null ? Colors.grey : Colors.white,
                width: 2,
              ),
              color: selectedVal == null
                  ? const Color(0xff0b3954) // Keep the background color consistent
                  : Colors.blue, // Changed button color when an option is selected
            ),
            alignment: Alignment.center,
            child: const Text(
              "Next",
              style: TextStyle(
                fontFamily: 'OpenSans',
                color: Colors.white, // Changed text color to white
                fontSize: 24,
                fontWeight: FontWeight.bold, // Made the text bold
              ),
            ),
          ),
          onTap: () {
            if (selectedVal == null) {
              noSelectionAlert(context);
              return;
            }
            if (_quizResult.containsKey(questions[question])) {
              _quizResult.update(questions[question], (value) => selectedVal as String);
            } else {
              _quizResult.putIfAbsent(questions[question], () => selectedVal as String);
            }

            if (question == 9) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LastSurveyPage(name: name, percent: percent + 10),
                ),
              );
            } else if (question == 6) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SurveyQuestionsMulti(
                    name: name,
                    choices: choicesData[question + 1],
                    question: question + 1,
                    percent: percent + 10,
                  ),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SurveyQuestions(
                    name: name,
                    choices: choicesData[question + 1],
                    question: question + 1,
                    percent: percent + 10,
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

/// Survey page for multi option questions.
class SurveyQuestionsMulti extends StatefulWidget {
  final String name;
  final List<String> choices;
  final int question;
  final int percent;

  const SurveyQuestionsMulti(
      {Key? key,
      required this.name,
      required this.choices,
      required this.question,
      required this.percent})
      : super(key: key);

  @override
  State<SurveyQuestionsMulti> createState() => _SurveyQuestionsMultiState();
}

/// Survey multi question page state.
class _SurveyQuestionsMultiState extends State<SurveyQuestionsMulti> {
  List<String> selectedItems = [];
  bool greyNext = true;
  double multiItemHeight = 0;
  bool noSymptoms = false;

  @override
  Widget build(BuildContext context) {
    final String name = widget.name;
    final List<String> choices = widget.choices;
    final int question = widget.question;
    final int percent = widget.percent;

    final Size size = MediaQuery.of(context).size;
    multiItemHeight = size.height / 10;

    return Scaffold(
      backgroundColor: const Color(0xff0b3954),
      appBar: AppBar(
        backgroundColor: const Color(0xff0b3954),
        actions: <Widget>[
          getProgressBar(percent, context),
          profileButton(context, name)
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                questions[question],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Column(
                  children: choices.map((item) {
                    return CheckboxListTile(
                      title: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      value: selectedItems.contains(item),
                      onChanged: (value) {
                        setState(() {
                          if (value != null && item == "None") {
                            noSymptoms = value;
                            selectedItems.clear(); // Clear other selections if "None" is selected
                          } else {
                            noSymptoms = false;
                          }

                          if (!noSymptoms) {
                            if (value != null && value) {
                              selectedItems.add(item);
                            } else {
                              selectedItems.remove(item);
                            }
                          }

                          greyNext = !selectedItems.isNotEmpty && !noSymptoms;
                        });
                      },
                    );
                  }).toList(),
                ),
            ],
          )
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GestureDetector(
          child: Container(
            width: 50,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              border: greyNext == true
                  ? Border.all(color: Colors.grey, width: 2)
                  : Border.all(color: Colors.white, width: 2),
              color: greyNext == true
                ? const Color(0xff0b3954)
                : Colors.blue
            ),
            alignment: Alignment.center,
            child: Text(
              "Next",
              style: greyNext == true
                  ? const TextStyle(
                fontFamily: 'OpenSans',
                color: Colors.grey,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              )
                  : const TextStyle(
                fontFamily: 'OpenSans',
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          onTap: () {
            String temp = '';
            for (int i = 0; i < selectedItems.length; i++) {
              temp += selectedItems[i];
              if (i < selectedItems.length - 1) {
                temp += "+";
              }
            }
            if (temp == "") {
              noSelectionAlert(context);
              return;
            }
            if (_quizResult.containsKey(questions[question])) {
              _quizResult.update(questions[question], (value) => temp);
            } else {
              _quizResult.putIfAbsent(questions[question], () => temp);
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SurveyQuestions(
                    name: name,
                    choices: choicesData[question + 1],
                    question: question + 1,
                    percent: percent + 10),
              ),
            );
          },
        ),
      ),
    );
  }
}

class LastSurveyPage extends StatefulWidget {
  final String name;
  final int percent;

  const LastSurveyPage({Key? key, required this.name, required this.percent})
      : super(key: key);

  @override
  State<LastSurveyPage> createState() => _LastSurveyPageState();
}

/// Last survey page state.
class _LastSurveyPageState extends State<LastSurveyPage> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final String name = widget.name;
    final int percent = widget.percent;

    return Scaffold(
      backgroundColor: const Color(0xff0b3954),
      appBar: AppBar(
        backgroundColor: const Color(0xff0b3954),
        actions: <Widget>[
          getProgressBar(percent, context),
          profileButton(context, name),
        ],
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20), // Increased horizontal padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Are you ready to submit?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20), // Adjusted padding
        child: GestureDetector(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
              border: Border.all(color: Colors.white, width: 2),
            ),
            alignment: Alignment.center,
            child: !loading
                ? const Text(
              "Submit",
              style: TextStyle(
                fontFamily: 'OpenSans',
                color: Color(0xff0b3954),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            )
                : const LoadingIndicator(
              indicatorType: Indicator.ballPulseSync,
              colors: Colors.primaries,
              backgroundColor: Colors.transparent,
              pathBackgroundColor: Colors.transparent,
            ),
          ),
          onTap: () async {
            if (!mounted) {
              Restart.restartApp();
            }
            setState(() {
              loading = true;
            });

            // Replace the following placeholders with your actual implementation
            final Map<String, dynamic> scoreData = collectScore(_quizResult);
            final List<SurveyScores> ss = await updateDatabase(scoreData, name, _quizResult);
            await scheduleNotifications();

            final int scoreToday = scoreData['score'];
            final String needs = scoreData['needs'];
            if (!mounted) return;
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => GraphSurvey(
                  gSS: ss,
                  scoreToday: scoreToday,
                  name: name,
                  needs: needs,
                ),
              ),
                  (_) => false,
            );
          },
        ),
      ),
    );
  }
}

Future<List<SurveyScores>> updateDatabase(Map<String, dynamic> scoreData,
    String name, Map<String, String> quizResult) async {
  if (await MongoDB.testDBConnection() == false) {
    await MongoDB.connect();
  }

  List<SurveyScores> ss = [];
  int score = scoreData['score']!;
  DateTime dateNow = DateTime.now();
  String dateToAdd = '${dateNow.month}/${dateNow.day}/${dateNow.year}';

  final prefs = await SharedPreferences.getInstance();
  List<String>? dates = prefs.getStringList("dates");
  List<String>? scores = prefs.getStringList("scores");

  if (dates == null || dates.isEmpty || scores == null || scores.isEmpty) {
    dates = [];
    scores = [];
  }
  dates.add(dateToAdd);
  scores.add(score.toString());

  for (int i = dates.length < 5 ? 0 : dates.length - 5; i < dates.length; i++) {
    ss.add(SurveyScores(dates[i], int.parse(scores[i])));
  }

  await prefs.setInt("scoreToday", score);
  await prefs.setString('lastSurveyDate', dateToAdd);
  await prefs.setString('needs', scoreData['needs']);
  await prefs.setStringList("dates", dates);
  await prefs.setStringList("scores", scores);

  // UPDATE DATABASE HERE
  Map<String, dynamic> user = await MongoDB.findUser(name);

  mongo_dart.ObjectId userId = user['_id'];
  scoreData["date"] = '$dateNow';
  scoreData["name"] = name;
  mongo_dart.ObjectId surveyId = await MongoDB.addSurvey(scoreData, userId);

  quizResult["date"] = '$dateNow';
  await MongoDB.addRawSurvey(quizResult, surveyId, userId);
  await MongoDB.updatePatientPrio(name, score);

  return ss;
}

/// Collect different metrics from the survey in a hashmap and return it.
Map<String, dynamic> collectScore(Map<String, String> quizResult) {
  Map<String, dynamic> scoreData = {};
  int score = 0;
  int breathing = 0;
  String breathingCompare = '';
  int heart = 0;
  int sleep = 0;
  String sleepCompare = '';
  int weight = 0;
  String weightCompare = '';
  // conditions
  List<String> condition = [];
  int energyLevels = 0;
  // need, last question
  String needs = quizResult[questions[9]].toString();

  for (String q in questions) {
    String ans = quizResult[q].toString();
    switch (q) {
      case "How is your breathing? \n(Choose one option)":
        switch (ans) {
          case "I am breathing well":
            score += 0;
            breathing = 0;
            break;
          case "I run out of breath when walking":
            score += 5;
            breathing = 5;
            break;
          case "I run out of breath when talking":
            score += 10;
            breathing = 10;
            break;
        }
        break;
      case "And this is: \n(Compare your breathing to yesterday)":
        switch (ans) {
          case "Better than yesterday":
            breathingCompare = "better";
            break;
          case "Same as yesterday":
            breathingCompare = "same";
            break;
          case "Worse than yesterday":
            breathingCompare = "worse";
            break;
        }
        break;
      case "How is your heart? \n(Choose one option)":
        switch (ans) {
          case "I feel great":
            score += 0;
            heart = 0;
            break;
          case "My heart is racing":
            score += 5;
            heart = 5;
            break;
          case "I have chest pain":
            score += 10;
            heart = 10;
            break;
        }
        break;
      case "How did you sleep last night? \n(Choose one option)":
        switch (ans) {
          case "I slept well last night":
            score += 0;
            sleep = 0;
            break;
          case "My sleep was restless":
            score += 5;
            sleep = 5;
            break;
          case "I had to use pillows to sit up in bed":
            score += 10;
            sleep = 10;
            break;
        }
        break;
      case "And this is: \n(Compare your sleep to yesterday)":
        switch (ans) {
          case "Better than yesterday":
            sleepCompare = "better";
            break;
          case "Same as yesterday":
            sleepCompare = "same";
            break;
          case "Worse than yesterday":
            sleepCompare = "worse";
            break;
        }
        break;
      case "How do you weigh today? \n(Choose one option)":
        switch (ans) {
          case "Gained 2 or more pounds since yesterday":
            score += 10;
            weight = 10;
            break;
          case "My clothes and shoes feel tight":
            score += 5;
            weight = 5;
            break;
          case "I can see swelling in my ankles":
            score += 5;
            weight = 5;
            break;
          case "My weight is the same or less than yesterday":
            score += 0;
            weight = 0;
            break;
        }
        break;
      case "And this is: \n(Compare your weight to yesterday)":
        switch (ans) {
          case "More than yesterday":
            weightCompare = "more";
            break;
          case "Same as yesterday":
            weightCompare = "same";
            break;
          case "Less than yesterday":
            weightCompare = "less";
            break;
        }
        break;
      case "Energy level: \n(Choose one option)":
        switch (ans) {
          case "Better than yesterday":
            score -= 5;
            energyLevels = 5;
            break;
          case "Same as yesterday":
            score += 0;
            energyLevels = 0;
            break;
          case "Worse than yesterday":
            score += 5;
            energyLevels = -5;
            break;
        }
        break;
      case 'I have: \n(Choose all that apply)':
        condition = ans.split('+');
        score += condition.length * 5;
        break;
    }
  }

  scoreData['score'] = score;
  scoreData['breathing'] = breathing;
  scoreData['breathing_compare'] = breathingCompare;
  scoreData['heart'] = heart;
  scoreData['sleep'] = sleep;
  scoreData['sleep_compare'] = sleepCompare;
  scoreData['weight'] = weight;
  scoreData['weight_compare'] = weightCompare;
  scoreData['condition'] = condition;
  scoreData['energy_levels'] = energyLevels;
  scoreData['needs'] = needs;
  return scoreData;
}
