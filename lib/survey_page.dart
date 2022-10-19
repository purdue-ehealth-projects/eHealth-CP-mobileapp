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

noSelectionAlert(BuildContext context) {
  // set up the button
  Widget okButton = TextButton(
    child: const Text("OK"),
    onPressed: () => Navigator.pop(context, 'Cancel'),
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("No Option Selected"),
    content: const Text("Please select an option."),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class SurveyWelcomePage extends StatefulWidget {
  final String username;
  const SurveyWelcomePage({Key? key, required this.username}) : super(key: key);

  @override
  State<SurveyWelcomePage> createState() => _SurveyWelcomePageState();
}

class _SurveyWelcomePageState extends State<SurveyWelcomePage> {
  @override
  Widget build(BuildContext context) {
    final String username = widget.username;
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xff0b3954),
      appBar: AppBar(
        backgroundColor: const Color(0xff0b3954),
        actions: <Widget>[getProgressBar(0, context)],
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
            child: SizedBox(
              height: size.height * 0.5,
              child: const Text(
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
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: GestureDetector(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7.5),
                child: Container(
                  width: size.width * 0.8,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
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
                        username: username,
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
  State<SurveyQuestions> createState() => _SurveyQuestionsState();
}

Map<String, String> x = {};
int score = 0;

class _SurveyQuestionsState extends State<SurveyQuestions> {
  String? selectedVal;

  @override
  Widget build(BuildContext context) {
    final String username = widget.username;
    final int question = widget.question;
    final List<String> choices = widget.choices;
    final int percent = widget.percent;

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff0b3954),
        actions: <Widget>[getProgressBar(percent, context)],
      ),
      body: Container(
        color: const Color(0xff0b3954),
        alignment: Alignment.center,
        child: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                child: Text(
                  questions[question],
                  style: const TextStyle(
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
                    hint: SizedBox(
                      width: size.width * 0.8,
                      child: const Text(
                        "Choose an option.",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    items: choices
                        .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: SizedBox(
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
                    dropdownDecoration: const BoxDecoration(
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
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
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
                  if (selectedVal == null) {
                    noSelectionAlert(context);
                  }

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
                            username: username, percent: percent + 10),
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
                            percent: percent + 10),
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
                            percent: percent + 10),
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
  State<SurveyQuestionsMulti> createState() => _SurveyQuestionsMultiState();
}

class _SurveyQuestionsMultiState extends State<SurveyQuestionsMulti> {
  List<String> selectedItems = [];

  @override
  Widget build(BuildContext context) {
    final String username = widget.username;
    final List<String> choices = widget.choices;
    final int question = widget.question;
    final int percent = widget.percent;

    List<String> selectedItems = [];
    Size size = MediaQuery.of(context).size;
    List<double> itemHeights = <double>[];

    for (int i = 0; i < choices.length; i++) {
      itemHeights.add(60);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff0b3954),
        actions: <Widget>[getProgressBar(percent, context)],
      ),
      body: Container(
        color: const Color(0xff0b3954),
        alignment: Alignment.center,
        child: ListView(scrollDirection: Axis.vertical, children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              child: Text(
                questions[question],
                style: const TextStyle(
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
                hint: const Align(
                  alignment: AlignmentDirectional.center,
                  child: Text(
                    'None apply.',
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
                        final isSelected = selectedItems.contains(item);
                        return InkWell(
                          onTap: () {
                            isSelected
                                ? selectedItems.remove(item)
                                : selectedItems.add(item);
                            //This rebuilds the StatefulWidget to update the button's text
                            setState(() {});
                            //This rebuilds the dropdownMenu Widget to update the check mark
                            menuSetState(() {});
                          },
                          child: SizedBox(
                            height: double.infinity,
                            child: Row(
                              children: [
                                isSelected
                                    ? const Icon(
                                        Icons.check_box_outlined,
                                        color: Colors.white,
                                      )
                                    : const Icon(Icons.check_box_outline_blank,
                                        color: Colors.white),
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
                //Use last selected item as the current value so if we've limited menu height, it scroll to last item.
                value: selectedItems.isEmpty ? null : selectedItems.last,
                onChanged: (value) {},
                dropdownDecoration: const BoxDecoration(
                  color: Color(0xff0b3954),
                ),
                iconEnabledColor: Colors.white,
                itemHeight: 100,
                customItemsHeights: itemHeights,
                dropdownMaxHeight: 700,
                scrollbarAlwaysShow: true,
                selectedItemBuilder: (context) {
                  return choices.map(
                    (item) {
                      return Container(
                        alignment: AlignmentDirectional.center,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        width: size.width * 0.8,
                        height: double.infinity,
                        child: Text(
                          selectedItems.join(', '),
                          maxLines: 5,
                          style: const TextStyle(
                            fontSize: 20,
                            overflow: TextOverflow.ellipsis,
                            color: Colors.white,
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
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
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
                  if (selectedItems.isEmpty) {
                    temp = "None";
                  } else {
                    for (int i = 0; i < selectedItems.length; i++) {
                      temp += selectedItems[i];
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
                      builder: (_) => SurveyQuestions(
                          username: username,
                          choices: choicesData[question + 1],
                          question: question + 1,
                          percent: percent + 10),
                    ),
                  );
                },
              ),
            ),
          ),
        ]),
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
  State<LastSurveyPage> createState() => _LastSurveyPageState();
}

class _LastSurveyPageState extends State<LastSurveyPage> {
  @override
  Widget build(BuildContext context) {
    final String username = widget.username;
    final int percent = widget.percent;

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff0b3954),
        actions: <Widget>[getProgressBar(percent, context)],
      ),
      body: Container(
        color: const Color(0xff0b3954),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40, horizontal: 10),
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
            const SizedBox(height: 300),
            GestureDetector(
              child: Container(
                width: size.width * 0.8,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                alignment: Alignment.center,
                child: const Text(
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
    if (temp.compareTo("I had to use pillows to sit up in bed") == 0) {
      score += 10;
    }

    if (temp.compareTo("My weight went up 2 or more pounds since yesterday") ==
        0) score += 10;
    if (temp.compareTo("My clothes and shoes feel tight") == 0) score += 5;
    if (temp.compareTo("I can see swelling in my ankles") == 0) score += 5;
    if (temp.compareTo("My weight is the same or less than yesterday") == 0) {
      score += 0;
    }

    if (temp.compareTo("I slept well last night") == 0) score += 0;
    if (temp.compareTo("My sleep was restless") == 0) score += 5;
    if (temp.compareTo("I had to use pillows to sit up in bed") == 0) {
      score += 10;
    }
  }

  return score;
}
