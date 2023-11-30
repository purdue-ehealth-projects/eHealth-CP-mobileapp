import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'database.dart';
import 'login_page.dart';
import 'privacy_policy.dart';

const double _actionFontSize = 18;

TextButton privacyPolicyButton(BuildContext context) {
  return TextButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PrivacyPolicyPage(),
        ),
      );
    },
    style: TextButton.styleFrom(
      foregroundColor: Colors.white,
    ),
    child: const Icon(Icons.privacy_tip),
  );
}

TextButton userManButton(BuildContext context) {
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

/// Button widget for profile page.
TextButton profileButton(BuildContext context, final String username) {
  return TextButton(
    // should be async?
    onPressed: () => _showProfile(context, username),
    style: TextButton.styleFrom(
      foregroundColor: Colors.white,
    ),
    child: const Icon(Icons.account_circle),
  );
}

Future<void> _showProfile(BuildContext context, final String name) async {
  if (await MongoDB.testDBConnection() == false) {
    await MongoDB.connect();
  }
  final Map<String, dynamic> patient = await MongoDB.findPatient(name);
  patient.removeWhere((key, value) => key == '_id');

  if (context.mounted) {
    if (Platform.isIOS) {
      // Cupertino-style alert for iOS
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
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
                }).toList(),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  'LOG OUT',
                  style: TextStyle(
                      fontSize: _actionFontSize, color: Colors.redAccent),
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
    } else {
      // Material-style alert for Android
      showDialog<void>(
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
                    e = Text("${_capitalizeWords(entry.key)}: ${entry.value}");
                  }
                  return e;
                }).toList(),
              ),
            ),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: <Widget>[
              TextButton(
                child: const Text(
                  'LOG OUT',
                  style: TextStyle(
                      fontSize: _actionFontSize, color: Colors.redAccent),
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
  }

}
String _capitalizeWords(String input) {
  List<String> words = input.split('_');
  words = words.map((word) => word.capitalize()).toList();
  return words.join(' ');
}

// Extension method to capitalize the first letter of a string
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
Future<void> _confirmLogout(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  final Widget okButton = TextButton(
    child: const Text(
      "LOG OUT",
      style: TextStyle(fontSize: _actionFontSize, color: Colors.redAccent),
    ),
    onPressed: () async {
      await prefs.clear();
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => const LoginPage(),
          ),
              (_) => false,
        );
      }
    },
  );

  final Widget noButton = TextButton(
    child: const Text(
      "CANCEL",
      style: TextStyle(fontSize: _actionFontSize),
    ),
    onPressed: () => Navigator.pop(context, 'Cancel'),
  );

  if (Platform.isIOS) {
    // Use CupertinoAlertDialog for iOS
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text("Confirm Logout"),
          content: const Text("Are you sure you want to log out?\n\n"
              "All your local data will be cleared, and you will need to log back in again.\n\n"
              "Your paramedic will still have all your past data."),
          //actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            okButton,
            noButton,
          ],
        );
      },
    );
  } else {
    // Use AlertDialog for Android
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
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
      },
    );
  }
}