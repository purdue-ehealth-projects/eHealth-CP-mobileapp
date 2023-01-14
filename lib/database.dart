import 'dart:convert';
import 'dart:math';

import 'package:basic_utils/basic_utils.dart';
import 'package:crypt/crypt.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// @Parameters: integer for the length of the random string.
///
/// @Return: a random string (salt).
String getSalt(final int len) {
  final random = Random.secure();
  final values = List<int>.generate(len, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}

/// @Parameters: string for password, string for salt.
///
/// @Return: a hashed and salted password.
/// Each user's password should have its unique salt.
String hashPassWithSalt(final String password, final String salt) {
  final secure = Crypt.sha256(password, salt: salt, rounds: 1000);
  return secure.toString();
}

String parseName(String original) {
  return StringUtils.capitalize(original.trim(), allWords: true);
}

/// Helper function log in user. Returns an error code.
///
/// @Return: 0 - success; 1 - name is empty; 2 - user doesn't exist
///  3 - wrong password.
Future<int> loginUser(final String name, final String password) async {
  if (name.isEmpty) {
    return 1;
  }
  if (await MongoDB.testDBConnection() == false) {
    await MongoDB.connect();
  }
  if (await MongoDB.existUser(name) == false) {
    return 2;
  }
  final user = await MongoDB.findUser(name);
  final String storedPassword = user['password'];
  final String salt = user['salt'];
  final encryptedPassword = hashPassWithSalt(password, salt);

  if (storedPassword == encryptedPassword) {
    return 0;
  } else {
    return 3;
  }
}

/// Ensure that a patient profile for user already exists. Returns an error
/// code.
///
/// @Return: 0 - success; 1 - empty input; 2 - patient profile doesn't exist;
/// 3 - user account already exists.
Future<int> validateUsername(final String name) async {
  if (name.isEmpty) {
    return 1;
  }
  if (await MongoDB.testDBConnection() == false) {
    await MongoDB.connect();
  }
  if (await MongoDB.existPatient(name) == false) {
    return 2;
  }
  if (await MongoDB.existUser(name) == true) {
    return 3;
  }
  return 0;
}

/// Push name and password to storage
Future<void> pushUserLocal(final String name, final String password) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('username', name);
  await prefs.setString('password', password);
}

/// Register user and create user account in MongoDB.
Future<void> pushUserMongoDB(final String name, final String password) async {
  await MongoDB.createUser(name, password);
}

/// This class handles database operations.
class MongoDB {
  /// Global static database and collection objects.
  static dynamic db,
      userCollection,
      patientCollection,
      surveyCollection,
      rawSurveyCollection;

  /// Close database.
  static Future<void> close() async {
    await db.close();
  }

  /// Connect app to database and define all global collections.
  static Future<void> connect() async {
    final String prePass = FlutterConfig.get('MONGO_CONN_PRE_PASSWORD');
    final String pass =
        Uri.encodeComponent(FlutterConfig.get('MONGO_CONN_PASSWORD'));
    final String postPass = FlutterConfig.get('MONGO_CONN_POST_PASSWORD');
    final String connection = "$prePass$pass$postPass";
    try {
      db = await Db.create(connection);
      await db.open();
    } catch (e) {
      return;
    }
    if (!db.masterConnection.serverCapabilities.supportsOpMsg) {
      return;
    }
    userCollection = db.collection(FlutterConfig.get('USER_COLLECTION'));
    patientCollection = db.collection(FlutterConfig.get('PATIENT_COLLECTION'));
    surveyCollection = db.collection(FlutterConfig.get('SURVEY_COLLECTION'));
    rawSurveyCollection =
        db.collection(FlutterConfig.get('RAW_SURVEY_COLLECTION'));
  }

  /// Checks if app is connected to database.
  static Future<bool> testDBConnection() async {
    try {
      // will not throw an error as long as there's connection
      await existUser("");
    } catch (e) {
      return false;
    }
    return true;
  }

  /// Checks if user exists in the database
  static Future<bool> existUser(final String name) async {
    return (await userCollection.findOne(where.eq('name', name)) != null);
  }

  /// Checks if patient exists in the database
  static Future<bool> existPatient(final String name) async {
    return (await patientCollection.findOne(where.eq('name', name)) != null);
  }

  /// Finds and returns user in the database.
  static Future<Map<String, dynamic>> findUser(final String name) async {
    return await userCollection.findOne(where.eq('name', name));
  }

  /// Finds and returns patient in the database.
  static Future<Map<String, dynamic>> findPatient(final String name) async {
    return await patientCollection.findOne(where.eq('name', name));
  }

  /// Updates patient priority based on their score
  static Future<void> updatePatientPrio(
      final String name, final int score) async {
    int priority = 0;
    if (score >= 0 && score <= 20) {
      priority = 3;
    } else if (score >= 25 && score <= 35) {
      priority = 2;
    } else {
      priority = 1;
    }
    await patientCollection.updateOne(
        where.eq('name', name), modify.set('priority', priority));
  }

  /// Creates a user entry in the database.
  static Future<void> createUser(
      final String name, final String password) async {
    var patient = await findPatient(name);
    dynamic userId = patient['_id'];
    // Generates a salt with length 10
    final salt = getSalt(10);
    final encryptedPassword = hashPassWithSalt(password, salt);
    await userCollection.insertOne({
      '_id': userId,
      'name': name,
      'password': encryptedPassword,
      'salt': salt,
    });
  }

  /// Adds a survey entry in the database.
  static Future<ObjectId> addSurvey(
      final Map<String, dynamic> surveyData, final ObjectId userId) async {
    final ObjectId surveyId = ObjectId();
    //surveyId = surveyId.substring(10, surveyId.length - 2);
    surveyData['_id'] = surveyId;
    surveyData['userId'] = userId;
    await surveyCollection.insertOne(surveyData);
    return surveyId;
  }

  /// Adds a raw survey entry in the database.
  static Future<void> addRawSurvey(final Map<String, String> rawSurvey,
      final ObjectId surveyId, final ObjectId userId) async {
    final Map<String, dynamic> toAdd = {};
    toAdd['_id'] = surveyId;
    for (final entry in rawSurvey.entries) {
      toAdd.putIfAbsent(entry.key, () => entry.value);
    }
    toAdd['userId'] = userId;
    await rawSurveyCollection.insertOne(toAdd);
  }

  /// Deletes a patient entry with the corresponding name.
  static Future<void> deletePatient(final String name) async {
    await patientCollection.deleteOne({'name': name});
  }

  /// Deletes a user entry with the corresponding name.
  static Future<void> deleteUser(final String name) async {
    await userCollection.deleteOne({'name': name});
  }

  /* Testing only */
  /*
  static dropTest() async {
    await db.dropCollection('users');
    userCollection = db.collection('users');
  }
  
  static printStuff() async {
    print(await userCollection.find().toList());
    print(await surveyCollection.find().toList());
    print(await rawSurveyCollection.find().toList());
  }
  
  static test() async {
    await db.dropCollection('patients');
    await db.dropCollection('users');
    patientCollection = db.collection('patients');
    userCollection = db.collection('users');

    var ret = await patientCollection.insertMany(<Map<String, dynamic>>[
      {'_id': 1, 'name': 'JACK', 'state': 'active', 'rating': 100, 'score': 5},
      {'_id': 2, 'name': 'William', 'state': 'busy', 'rating': 80, 'score': 4},
      {'_id': 3, 'name': 'Liz', 'state': 'on hold', 'rating': 70, 'score': 8},
      {'_id': 4, 'name': 'George', 'state': 'active', 'rating': 95, 'score': 8},
      {'_id': 5, 'name': 'Jim', 'state': 'idle', 'rating': 40, 'score': 3},
      {'_id': 6, 'name': 'Laureen', 'state': 'busy', 'rating': 87, 'score': 8},
      {'_id': 7, 'name': 'John', 'state': 'idle', 'rating': 72, 'score': 7}
    ]);

    await createPatient('JAMIE', '19', '03/07/2001', 'testingid123');
    String salt = getSalt(10);
    String password = hashPassWithSalt("password", salt);
    await createUser('BOB', password, salt);
    await updateUser('BOB', 'testpass', 'salty');
    if (!ret.isSuccess) {
      //print('Error detected in record insertion');
    }

    //dynamic res = await patientCollection
    //    .findOne(where.eq('name', 'Liz').gt('rating', 7));

    //print('First document fetched: ${res['name']} - ${res['state']}');
    await close();
  }
  */
}
