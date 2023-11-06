/// Contains reusable widgets (buttons and alerts).
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

const double _alertTitleSize = 20;
const double _alertMsgSize = 18;
const double _actionFontSize = 18;

/// Login failed alert pop up
void loginFailedAlert(BuildContext context, final int errCode) {
  if (Platform.isIOS) {
    _showCupertinoDialog(context, errCode);
  } else {
    _showMaterialDialog(context, errCode);
  }
}

void _showCupertinoDialog(BuildContext context, final int errCode) {
  final Widget okButton = CupertinoDialogAction(
    child: const Text("OK", style: TextStyle(fontSize: 16.0)),
    onPressed: () => Navigator.pop(context, 'Cancel'),
  );

  CupertinoAlertDialog alert = CupertinoAlertDialog(
    title: const Text("Login Failed", style: TextStyle(fontSize: 20.0)),
    content: Text(
      _getErrorMessage(errCode),
      style: const TextStyle(fontSize: 16.0),
    ),
    actions: [okButton],
  );

  showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

void _showMaterialDialog(BuildContext context, final int errCode) {
  final Widget okButton = TextButton(
    child: const Text(
      "OK",
      style: TextStyle(fontSize: 16.0),
    ),
    onPressed: () => Navigator.pop(context, 'Cancel'),
  );

  AlertDialog alert = AlertDialog(
    title: const Text("Login Failed", style: TextStyle(fontSize: 20.0)),
    content: Text(
      _getErrorMessage(errCode),
      style: const TextStyle(fontSize: 16.0),
    ),
    actions: [okButton],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

String _getErrorMessage(int errCode) {
  switch (errCode) {
    case 1:
      return "Name cannot be empty.";
    case 2:
      return "This user doesn't exist. Please create a new user account.";
    case 3:
      return "Wrong Password. Please try again.";
    default:
      return "Login Failed";
  }
}

/// Register failed alert pop up
void validateUserFailedAlert(BuildContext context, final int errCode) {
  if (Platform.isIOS) {
    _showCupertinoDialogR(context, errCode);
  } else {
    _showMaterialDialogR(context, errCode);
  }
}

void _showCupertinoDialogR(BuildContext context, final int errCode) {
  final Widget okButton = CupertinoDialogAction(
    child: const Text("OK", style: TextStyle(fontSize: 16.0)),
    onPressed: () => Navigator.pop(context, 'Cancel'),
  );

  CupertinoAlertDialog alert = CupertinoAlertDialog(
    title: const Text("Register Failed", style: TextStyle(fontSize: 20.0)),
    content: Text(
      _getErrorMessageR(errCode),
      style: const TextStyle(fontSize: 16.0),
    ),
    actions: [okButton],
  );

  showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

void _showMaterialDialogR(BuildContext context, final int errCode) {
  final Widget okButton = TextButton(
    child: const Text(
      "OK",
      style: TextStyle(fontSize: 16.0),
    ),
    onPressed: () => Navigator.pop(context, 'Cancel'),
  );

  AlertDialog alert = AlertDialog(
    title: const Text("Register Failed", style: TextStyle(fontSize: 20.0)),
    content: Text(
      _getErrorMessageR(errCode),
      style: const TextStyle(fontSize: 16.0),
    ),
    actions: [okButton],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

String _getErrorMessageR(int errCode) {
  switch (errCode) {
    case 1:
      return "Name cannot be empty.";
    case 2:
      return "No patient profile found with the given name. Please check with your paramedic.";
    case 3:
      return "User with the given name already exists. Please log in instead.";
    default:
      return "Register Failed";
  }
}

/// Bad password alert pop up
void badPasswordAlert(BuildContext context) {
  if (Platform.isIOS) {
    _showCupertinoDialogB(context);
  } else {
    _showMaterialDialogB(context);
  }
}

void _showCupertinoDialogB(BuildContext context) {
  final Widget okButton = CupertinoDialogAction(
    child: const Text("OK", style: TextStyle(fontSize: 16.0)),
    onPressed: () => Navigator.pop(context, 'Cancel'),
  );

  CupertinoAlertDialog alert = CupertinoAlertDialog(
    title: const Text("Insecure Password", style: TextStyle(fontSize: 20.0)),
    content: const Text(
      "Password is too weak.",
      style: TextStyle(fontSize: 16.0),
    ),
    actions: [okButton],
  );

  showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

void _showMaterialDialogB(BuildContext context) {
  final Widget okButton = TextButton(
    child: const Text(
      "OK",
      style: TextStyle(fontSize: 16.0),
    ),
    onPressed: () => Navigator.pop(context, 'Cancel'),
  );

  AlertDialog alert = AlertDialog(
    title: const Text("Insecure Password", style: TextStyle(fontSize: 20.0)),
    content: const Text(
      "Password is too weak.",
      style: TextStyle(fontSize: 16.0),
    ),
    actions: [okButton],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

/// Alert pop up when no option is seleted.
void noSelectionAlert(BuildContext context) {
  if (Platform.isIOS) {
    _showCupertinoDialogS(context);
  } else {
    _showMaterialDialogS(context);
  }
}

void _showCupertinoDialogS(BuildContext context) {
  final Widget okButton = CupertinoDialogAction(
    child: const Text("OK", style: TextStyle(fontSize: 16.0)),
    onPressed: () => Navigator.pop(context, 'Cancel'),
  );

  CupertinoAlertDialog alert = CupertinoAlertDialog(
    title: const Text("No Option Selected", style: TextStyle(fontSize: 20.0)),
    content: const Text(
      "Please select an option.",
      style: TextStyle(fontSize: 16.0),
    ),
    actions: [okButton],
  );

  showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

void _showMaterialDialogS(BuildContext context) {
  final Widget okButton = TextButton(
    child: const Text(
      "OK",
      style: TextStyle(fontSize: 16.0),
    ),
    onPressed: () => Navigator.pop(context, 'Cancel'),
  );

  AlertDialog alert = AlertDialog(
    title: const Text("No Option Selected", style: TextStyle(fontSize: 20.0)),
    content: const Text(
      "Please select an option.",
      style: TextStyle(fontSize: 16.0),
    ),
    actions: [okButton],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

void passwordsMustMatchAlert(BuildContext context) {
  if (Platform.isIOS) {
    _showCupertinoDialogP(context);
  } else {
    _showMaterialDialogP(context);
  }
}

void _showCupertinoDialogP(BuildContext context) {
  final Widget okButton = CupertinoDialogAction(
    child: const Text("OK", style: TextStyle(fontSize: 16.0)),
    onPressed: () => Navigator.pop(context, 'Cancel'),
  );

  CupertinoAlertDialog alert = CupertinoAlertDialog(
    title: const Text("Passwords Must Match", style: TextStyle(fontSize: 20.0)),
    content: const Text(
      "Both passwords must match. Please try again.",
      style: TextStyle(fontSize: 16.0),
    ),
    actions: [okButton],
  );

  showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

void _showMaterialDialogP(BuildContext context) {
  final Widget okButton = TextButton(
    child: const Text(
      "OK",
      style: TextStyle(fontSize: 16.0),
    ),
    onPressed: () => Navigator.pop(context, 'Cancel'),
  );

  AlertDialog alert = AlertDialog(
    title: const Text("Passwords Must Match", style: TextStyle(fontSize: 20.0)),
    content: const Text(
      "Both passwords must match. Please try again.",
      style: TextStyle(fontSize: 16.0),
    ),
    actions: [okButton],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}