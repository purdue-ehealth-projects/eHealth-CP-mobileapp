/// Contains alert dialogs

import 'package:flutter/material.dart';

/// Login failed alert pop up
loginFailedAlert(BuildContext context, int errCode) {
  // set up the button
  Widget okButton = TextButton(
    child: const Text(
      "OK",
      style: TextStyle(fontSize: 18),
    ),
    onPressed: () => Navigator.pop(context, 'Cancel'),
  );

  // set up the AlertDialog
  AlertDialog alert = const AlertDialog();
  if (errCode == 1) {
    alert = AlertDialog(
      title: const Text(
        "Login Failed",
        style: TextStyle(fontSize: 20),
      ),
      content: const Text(
        "Wrong Password. Please try again.",
        style: TextStyle(fontSize: 18),
      ),
      actions: [
        okButton,
      ],
    );
  } else if (errCode == 2) {
    alert = AlertDialog(
      title: const Text(
        "Login Failed",
        style: TextStyle(fontSize: 20),
      ),
      content: const Text(
        "This user doesn't exist. Please create a new user account.",
        style: TextStyle(fontSize: 18),
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
      style: TextStyle(fontSize: 18),
    ),
    onPressed: () => Navigator.pop(context, 'Cancel'),
  );

  // set up the AlertDialog
  AlertDialog alert = const AlertDialog();
  if (errCode == 1) {
    alert = AlertDialog(
      title: const Text(
        "Register Failed",
        style: TextStyle(fontSize: 20),
      ),
      content: const Text(
        "Name cannot be empty.",
        style: TextStyle(fontSize: 18),
      ),
      actions: [
        okButton,
      ],
    );
  } else if (errCode == 2) {
    alert = AlertDialog(
      title: const Text(
        "Register Failed",
        style: TextStyle(fontSize: 20),
      ),
      content: const Text(
        "No patient profile found with the given name. Please check with your paramedic.",
        style: TextStyle(fontSize: 18),
      ),
      actions: [
        okButton,
      ],
    );
  } else if (errCode == 3) {
    alert = AlertDialog(
      title: const Text(
        "Register Failed",
        style: TextStyle(fontSize: 20),
      ),
      content: const Text(
        "User with given name already exists. Please log in instead.",
        style: TextStyle(fontSize: 18),
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
      style: TextStyle(fontSize: 18),
    ),
    onPressed: () => Navigator.pop(context, 'Cancel'),
  );

  AlertDialog alert = AlertDialog(
    title: const Text(
      "Insecure Password",
      style: TextStyle(fontSize: 20),
    ),
    content: const Text(
      "Password is too weak.",
      style: TextStyle(fontSize: 18),
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
      style: TextStyle(fontSize: 18),
    ),
    onPressed: () => Navigator.pop(context, 'Cancel'),
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text(
      "No Option Selected",
      style: TextStyle(fontSize: 20),
    ),
    content: const Text(
      "Please select an option.",
      style: TextStyle(fontSize: 18),
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
