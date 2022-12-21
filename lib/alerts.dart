/// Contains reusable widgets (buttons and alerts).
import 'package:flutter/material.dart';

const double _alertTitleSize = 20;
const double _alertMsgSize = 18;
const double _actionFontSize = 18;

/// Login failed alert pop up
loginFailedAlert(BuildContext context, final int errCode) {
  // set up the button
  final Widget okButton = TextButton(
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
validateUserFailedAlert(BuildContext context, final int errCode) {
  // set up the button
  final Widget okButton = TextButton(
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
  final Widget okButton = TextButton(
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
  final Widget okButton = TextButton(
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
