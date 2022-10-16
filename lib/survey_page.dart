import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:emshealth/completion_page.dart';
import 'package:emshealth/survey_data.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

LinearPercentIndicator getProgressBar(int percent, BuildContext context) {
  return LinearPercentIndicator(
    alignment: MainAxisAlignment.center,
    width: MediaQuery.of(context).size.width -
        MediaQuery.of(context).size.width * 0.4,
    center: Text(percent.toString() + "%",
        style: const TextStyle(color: Colors.black)),
    lineHeight: 25.0,
    percent: (percent / 100).toDouble(),
    backgroundColor: Colors.white,
    barRadius: const Radius.circular(10),
    progressColor: Color(0xff0b3954).withOpacity(0.5),
    animation: true,
    animationDuration: 500,
  );
}

class SurveyWelcomePage extends StatefulWidget {
  final String username;
  const SurveyWelcomePage({Key? key, required this.username}) : super(key: key);

  @override
  _SurveyWelcomePageState createState() =>
      _SurveyWelcomePageState(this.username);
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
                      color: Colors.white),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: GestureDetector(
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
                    builder: (_) => SurveyQuestions(
                        username: this.username,
                        choices: choicesData[0],
                        question: 0,
                        percent: 0.toInt()),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SurveyQuestions extends StatefulWidget {
  final List<String> choices;
  final int question;
  final int percent;
  final String username;

  const SurveyQuestions(
      {Key? key,
      required this.choices,
      required this.question,
      required this.percent,
      required this.username})
      : super(key: key);

  @override
  _SurveyQuestions createState() => _SurveyQuestions(
      this.username, this.choices, this.question, this.percent);
}

Map<String, String> x = new Map();
int score = 0;

class _SurveyQuestions extends State<SurveyQuestions> {
  final String username;
  final List<String> choices;
  final int question;
  final int percent;

  String? selectedVal;

  _SurveyQuestions(this.username, this.choices, this.question, this.percent);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedVal = choices[0];
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
        child: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                child: Text(
                  questions[question],
                  style: TextStyle(
                      color: Colors.white,
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    hint: Container(
                      width: size.width * 0.8,
                      child: Text(
                        "Choose an option.",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    items: choices
                        .map((item) =>
                        DropdownMenuItem<String>(
                          value: item,
                          child: Container(
                            width: size.width * 0.8,
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ))
                        .toList(),
                    dropdownDecoration: BoxDecoration(
                      color: Color(0xff0b3954),
                    ),
                    iconEnabledColor: Colors.white,
                    value: selectedVal,
                    onChanged: (value) {
                      setState(() {
                        selectedVal = value as String;
                      });
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: SizedBox(
                  child: GestureDetector(
                    child: Container(
                      width: 50,
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
                        x.update(
                            questions[question], (value) => selectedVal as String);
                      } else {
                        x.putIfAbsent(
                            questions[question], () => selectedVal as String);
                      }

                      if (question == 9) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LastSurveyPage(
                                username: username, percent: this.percent + 10),
                          ),
                        );
                      } else if (question == 6) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SurveyQuestionsMulti(
                                username: username,
                                choices: choicesData[question + 1],
                                question: question + 1,
                                percent: this.percent + 10),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SurveyQuestions(
                                username: username,
                                choices: choicesData[question + 1],
                                question: question + 1,
                                percent: this.percent + 10),
                          ),
                        );
                      }
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

class SurveyQuestionsMulti extends StatefulWidget {
  final String username;
  final List<String> choices;
  final int question;
  final int percent;

  const SurveyQuestionsMulti(
      {Key? key,
      required this.username,
      required this.choices,
      required this.question,
      required this.percent})
      : super(key: key);

  @override
  _SurveyQuestionsMultiState createState() => _SurveyQuestionsMultiState(
      this.username, this.choices, this.question, this.percent);
}

class _SurveyQuestionsMultiState extends State<SurveyQuestionsMulti> {
  final String username;
  final List<String> choices;
  final int question;
  final int percent;
  List<String> selectedItems = [];

  _SurveyQuestionsMultiState(this.username, this.choices, this.question, this.percent);


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
        child: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                child: Text(
                  questions[question],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                child: DropdownButtonHideUnderline(
                child: DropdownButton2(
                  isExpanded: true,
                  hint: Align(
                    alignment: AlignmentDirectional.center,
                    child: Text(
                      'Select multiple options.',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  items: choices.map((item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: StatefulBuilder(
                        builder: (context, menuSetState) {
                          final _isSelected = selectedItems.contains(item);
                          return InkWell(
                            onTap: () {
                              _isSelected
                                  ? selectedItems.remove(item)
                                  : selectedItems.add(item);
                              //This rebuilds the StatefulWidget to update the button's text
                              setState(() {});
                              //This rebuilds the dropdownMenu Widget to update the check mark
                              menuSetState(() {});
                            },
                            child: Container(
                              height: double.infinity,
                              child: Row(
                                children: [
                                  _isSelected
                                      ? const Icon(Icons.check_box_outlined, color: Colors.white,)
                                      : const Icon(Icons.check_box_outline_blank, color: Colors.white),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 200,
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }).toList(),
                  value: selectedItems.isEmpty ? null : selectedItems.last,
                  onChanged: (value) {},
                  dropdownDecoration: BoxDecoration(
                    color: Color(0xff0b3954),
                  ),
                  iconEnabledColor: Colors.white,
                  itemHeight: 60,
                  dropdownMaxHeight: 700,
                  scrollbarAlwaysShow: true,
                  selectedItemBuilder: (context) {
                    return choices.map(
                          (item) {
                        return Container(
                          alignment: AlignmentDirectional.center,
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Container(
                            width: size.width * 0.8,
                            child: Text(
                              selectedItems.join(', '),
                              style: const TextStyle(
                                fontSize: 20,
                                overflow: TextOverflow.ellipsis,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ).toList();
                  },
                )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: SizedBox(
                  child: GestureDetector(
                    child: Container(
                      width: 50,
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
                      String temp = '';
                      for (int i = 0; i < selectedItems.length; i++) {
                          temp += selectedItems[i];
                          temp += "+";
                        }
                      if (x.containsKey(questions[question])) {
                        x.update(questions[question], (value) => temp);
                      } else {
                        x.putIfAbsent(questions[question], () => temp);
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SurveyQuestions(
                              username: username,
                              choices: choicesData[question + 1],
                              question: question + 1,
                              percent: this.percent + 10),
                        ),
                      );
                    },
                  ),
              ),
            ),
          ]
        ),
      ),
    );
  }
}

class LastSurveyPage extends StatefulWidget {
  final String username;
  final int percent;

  const LastSurveyPage(
      {Key? key, required this.username, required this.percent})
      : super(key: key);

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
                      color: Colors.white),
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
                    builder: (_) => CompletionPage(
                        name: username,
                        score: scoreQ,
                        quizResult: x,
                        needs: x[questions[9]].toString()),
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
    if (temp.compareTo("I had to use pillows to sit up in bed") == 0)
      score += 10;

    if (temp.compareTo("My weight went up 2 or more pounds since yesterday") ==
        0) score += 10;
    if (temp.compareTo("My clothes and shoes feel tight") == 0) score += 5;
    if (temp.compareTo("I can see swelling in my ankles") == 0) score += 5;
    if (temp.compareTo("My weight is the same or less than yesterday") == 0)
      score += 0;

    if (temp.compareTo("I slept well last night") == 0) score += 0;
    if (temp.compareTo("My sleep was restless") == 0) score += 5;
    if (temp.compareTo("I had to use pillows to sit up in bed") == 0)
      score += 10;
  }

  return score;
}

