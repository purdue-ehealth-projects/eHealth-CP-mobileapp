//import 'package:flutter/cupertino.dart';

List<String> questions = [
  "How is your breathing? \n(Choose one option)",
  "And this is: \n(Compare your breathing to yesterday)",
  "How is your heart? \n(Choose one option)",
  'How did you sleep last night? \n(Choose one option)',
  "And this is: \n(Compare your sleep to yesterday)",
  'How do you weigh today? \n(Choose one option)',
  "And this is: \n(Compare your weight to yesterday)",
  'I have: \n(Choose all that apply)',
  "Energy level: \n(Choose one option)",
  "I feel like I need: \n(Choose one option)"
];

List<List<String>> choicesData = [
  [
    "I am breathing well",
    "I run out of breath when walking",
    "I run out of breath when talking"
  ],
  ["Better than yesterday", "Same as yesterday", "Worse than yesterday"],
  ["I feel great", "My heart is racing", "I have chest pain"],
  [
    "I slept well last night",
    "My sleep was restless",
    "I had to use pillows to sit up in bed"
  ],
  ["Better than yesterday", "Same as yesterday", "Worse than yesterday"],
  [
    'My weight went up 2 or more pounds since yesterday',
    'My clothes and shoes feel tight',
    'I can see swelling in my ankles',
    'My weight is the same or less than yesterday'
  ],
  ['More than yesterday', 'Same as yesterday', 'Less than yesterday'],
  [
    'Aching all over',
    'A headache',
    'Nausea',
    'A new concern or problem that came back'
  ],
  ["Better than yesterday", "Same as yesterday", "Worse than yesterday"],
  ['A phone call', 'A visit', 'Nothing! I\'m good today :)'],
];
