/// Contains reusable widgets (buttons and alerts).
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'database.dart';
import 'login_page.dart';

TextButton privacyPolicyBtn(BuildContext context) {
  return TextButton(
    onPressed: () => launchUrl(
        Uri.parse(
            'https://gist.github.com/carl2x/3b79730cdd9ae5f8d746c817d2772a2a'),
        mode: LaunchMode.platformDefault),
    style: TextButton.styleFrom(
      foregroundColor: Colors.white,
    ),
    child: const Icon(Icons.privacy_tip),
  );
}

TextButton userManBtn(BuildContext context) {
  return TextButton(
    onPressed: () => launchUrl(
        Uri.parse(
            'https://github.com/ktong2023/eHealth-EMS-mobile/blob/main/USER_MANUAL.md'),
        mode: LaunchMode.platformDefault),
    style: TextButton.styleFrom(
      foregroundColor: Colors.white,
    ),
    child: const Icon(Icons.help),
  );
}

const double _alertTitleSize = 20;
const double _alertMsgSize = 18;
const double _actionFontSize = 18;

/// Login failed alert pop up
loginFailedAlert(BuildContext context, int errCode) {
  // set up the button
  Widget okButton = TextButton(
    child: const Text(
      "OK",
      style: TextStyle(fontSize: _actionFontSize),
    ),
    onPressed: () => Navigator.pop(context, 'Cancel'),
  );

  // set up the AlertDialog
  AlertDialog alert = const AlertDialog();
  if (errCode == 1) {
    alert = AlertDialog(
      title: const Text(
        "Login Failed",
        style: TextStyle(fontSize: _alertTitleSize),
      ),
      content: const Text(
        "Name cannot be empty.",
        style: TextStyle(fontSize: _alertMsgSize),
      ),
      actions: [
        okButton,
      ],
    );
  } else if (errCode == 2) {
    alert = AlertDialog(
      title: const Text(
        "Login Failed",
        style: TextStyle(fontSize: _alertTitleSize),
      ),
      content: const Text(
        "This user doesn't exist. Please create a new user account.",
        style: TextStyle(fontSize: _alertMsgSize),
      ),
      actions: [
        okButton,
      ],
    );
  } else if (errCode == 3) {
    alert = AlertDialog(
      title: const Text(
        "Login Failed",
        style: TextStyle(fontSize: _alertTitleSize),
      ),
      content: const Text(
        "Wrong Password. Please try again.",
        style: TextStyle(fontSize: _alertMsgSize),
      ),
      actions: [
        okButton,
      ],
    );
  }

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

/// Register failed alert pop up
validateUserFailedAlert(BuildContext context, int errCode) {
  // set up the button
  Widget okButton = TextButton(
    child: const Text(
      "OK",
      style: TextStyle(fontSize: _actionFontSize),
    ),
    onPressed: () => Navigator.pop(context, 'Cancel'),
  );

  // set up the AlertDialog
  AlertDialog alert = const AlertDialog();
  if (errCode == 1) {
    alert = AlertDialog(
      title: const Text(
        "Register Failed",
        style: TextStyle(fontSize: _alertTitleSize),
      ),
      content: const Text(
        "Name cannot be empty.",
        style: TextStyle(fontSize: _alertMsgSize),
      ),
      actions: [
        okButton,
      ],
    );
  } else if (errCode == 2) {
    alert = AlertDialog(
      title: const Text(
        "Register Failed",
        style: TextStyle(fontSize: _alertTitleSize),
      ),
      content: const Text(
        "No patient profile found with the given name. Please check with your paramedic.",
        style: TextStyle(fontSize: _alertMsgSize),
      ),
      actions: [
        okButton,
      ],
    );
  } else if (errCode == 3) {
    alert = AlertDialog(
      title: const Text(
        "Register Failed",
        style: TextStyle(fontSize: _alertTitleSize),
      ),
      content: const Text(
        "User with given name already exists. Please log in instead.",
        style: TextStyle(fontSize: _alertMsgSize),
      ),
      actions: [
        okButton,
      ],
    );
  }

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

/// Bad password alert pop up
badPasswordAlert(BuildContext context) {
  Widget okButton = TextButton(
    child: const Text(
      "OK",
      style: TextStyle(fontSize: _actionFontSize),
    ),
    onPressed: () => Navigator.pop(context, 'Cancel'),
  );

  AlertDialog alert = AlertDialog(
    title: const Text(
      "Insecure Password",
      style: TextStyle(fontSize: _alertTitleSize),
    ),
    content: const Text(
      "Password is too weak.",
      style: TextStyle(fontSize: _alertMsgSize),
    ),
    actions: [
      okButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

/// Alert pop up when no option is seleted.
noSelectionAlert(BuildContext context) {
  // set up the button
  Widget okButton = TextButton(
    child: const Text(
      "OK",
      style: TextStyle(fontSize: _actionFontSize),
    ),
    onPressed: () => Navigator.pop(context, 'Cancel'),
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text(
      "No Option Selected",
      style: TextStyle(fontSize: _alertTitleSize),
    ),
    content: const Text(
      "Please select an option.",
      style: TextStyle(fontSize: _alertMsgSize),
    ),
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

/// Button widget for profile page.
TextButton profileButton(BuildContext context, String username) {
  return TextButton(
    // should be async?
    onPressed: () => _showProfile(context, username),
    style: TextButton.styleFrom(
      foregroundColor: Colors.white,
    ),
    child: const Icon(Icons.account_circle),
  );
}

/// Returns a patient profile page pop-up for the user.
Future<void> _showProfile(BuildContext context, String name) async {
  if (await MongoDB.testDBConnection() == false) {
    await MongoDB.connect();
  }
  Map<String, dynamic> patient = await MongoDB.findPatient(name);
  patient.removeWhere((key, value) => key == '_id');

  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Patient Profile Page'),
        content: SingleChildScrollView(
            child: ListBody(
                children: patient.entries.map((entry) {
          var e = const Text("");
          if (entry.key == 'name') {
            e = Text(
              "${entry.key}: ${entry.value}",
              style: const TextStyle(fontSize: 18),
            );
          } else {
            e = Text("${entry.key}: ${entry.value}");
          }
          return e;
        }).toList())),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: <Widget>[
          TextButton(
            child: const Text(
              'LOG OUT',
              style:
                  TextStyle(fontSize: _actionFontSize, color: Colors.redAccent),
            ),
            onPressed: () async {
              await _confirmLogout(context);
            },
          ),
          TextButton(
            child: const Text(
              'DISMISS',
              style: TextStyle(fontSize: _actionFontSize),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

/// Dialog to confirm log out
_confirmLogout(BuildContext context) async {
  // Define navigator before any async calls
  final navigator = Navigator.of(context);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Widget okButton = TextButton(
    child: const Text(
      "LOG OUT",
      style: TextStyle(fontSize: _actionFontSize, color: Colors.redAccent),
    ),
    onPressed: () async {
      await prefs.clear();
      navigator.pushAndRemoveUntil(
          MaterialPageRoute(
            // direct to login and not home so prefs.clear() won't get
            // called twice
            builder: (_) => const LoginPage(),
          ),
          (_) => false);
    },
  );
  Widget noButton = TextButton(
    child: const Text(
      "CANCEL",
      style: TextStyle(fontSize: _actionFontSize),
    ),
    onPressed: () => Navigator.pop(context, 'Cancel'),
  );

  AlertDialog alert = AlertDialog(
    title: const Text("Confirm Logout"),
    content: const Text("Are you sure you want to log out?\n\n"
        "All your local data will be cleared, and you will need to log back in again.\n\n"
        "Your paramedic will still have all your past data."),
    actionsAlignment: MainAxisAlignment.spaceBetween,
    actions: [
      okButton,
      noButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
