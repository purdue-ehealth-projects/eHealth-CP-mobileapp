import 'package:mongo_dart/mongo_dart.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:crypt/crypt.dart';
import 'dart:math';
import 'dart:convert';

/// This class handles database operations.
class MongoDB {
  /// Global static database and collection objects.
  static dynamic db,
      userCollection,
      patientCollection,
      surveyCollection,
      rawSurveyCollection;

  static Future cleanupDatabase() async {
    await db.close();
  }

  /// @Parameters: integer for the length of the random string.
  ///
  /// @Return: a random string (salt).
  static String getSalt(int len) {
    var random = Random.secure();
    var values = List<int>.generate(len, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }

  /// @Parameters: string for password, string for salt.
  ///
  /// @Return: a hashed and salted password.
  /// Each user's password should have its unique salt.
  static String hashPassWithSalt(String password, String salt) {
    final secure = Crypt.sha256(password, salt: salt, rounds: 1000);
    return secure.toString();
  }

  /// Connect app to MongoDB database
  static connect() async {
    final String prePass = FlutterConfig.get('MONGO_CONN_PRE_PASSWORD');
    final String pass =
        Uri.encodeComponent(FlutterConfig.get('MONGO_CONN_PASSWORD'));
    final String postPass = FlutterConfig.get('MONGO_CONN_POST_PASSWORD');
    String connection = "$prePass$pass$postPass";
    //print(connection);
    db = await Db.create(connection);
    await db.open();
    userCollection = db.collection(FlutterConfig.get('USER_COLLECTION'));
    patientCollection = db.collection(FlutterConfig.get('PATIENT_COLLECTION'));
    surveyCollection = db.collection(FlutterConfig.get('SURVEY_COLLECTION'));
    rawSurveyCollection =
        db.collection(FlutterConfig.get('RAW_SURVEY_COLLECTION'));

    if (!db.masterConnection.serverCapabilities.supportsOpMsg) {
      return;
    }
  }

  /// Checks if user exists in the database
  static Future<bool> existUser(String name) async {
    if (await userCollection.findOne(where.eq('name', name)) != null) {
      return true;
    }
    return false;
  }

  /// Checks if patient exists in the database
  static Future<bool> existPatient(String name) async {
    if (await patientCollection.findOne(where.eq('name', name)) != null) {
      return true;
    }
    return false;
  }

  /// Finds and returns user in the database.
  static Future<Map<String, dynamic>> findUser(String name) async {
    return await userCollection.findOne(where.eq('name', name));
  }

  /// Finds and returns patient in the database.
  static Future<Map<String, dynamic>> findPatient(String name) async {
    return await patientCollection.findOne(where.eq('name', name));
  }

  /// Currently not used
  static updateUser(String name, String password, String salt) async {
    var user = await findUser(name);
    user['password'] = password;
    user['salt'] = salt;
    await userCollection.save(user);
  }

  /// Creates a user entry in the database.
  static createUser(String name, String password, String salt) async {
    var patient = await MongoDB.findPatient(name);
    dynamic userId = patient['_id'];
    await userCollection.insertOne({
      '_id': userId,
      'name': name,
      'password': password,
      'salt': salt,
    });
  }

  /// Adds a survey entry in the database.
  static Future<String> addSurvey(
      Map<String, dynamic> survey, String userId) async {
    String surveyId = ObjectId().toString();
    surveyId = surveyId.substring(10, surveyId.length - 2);
    survey['_id'] = surveyId;
    survey['userId'] = userId;
    await surveyCollection.insertOne(survey);
    return surveyId;
  }

  /// Adds a raw survey entry in the database.
  static addRawSurvey(
      Map<String, String> rawSurvey, String surveyId, String userId) async {
    Map<String, dynamic> toAdd = {};
    toAdd['_id'] = surveyId;
    toAdd['userId'] = userId;
    for (final entry in rawSurvey.entries) {
      toAdd.putIfAbsent(entry.key, () => entry.value);
    }
    await rawSurveyCollection.insertOne(toAdd);
  }

  /// Creates a patient entry in the database.
  static createPatient(
      String name, String age, String dob, String userId) async {
    await patientCollection.insertOne({
      '_id': userId,
      'name': name,
      'address': '',
      'age': age,
      'appointment_day': '',
      'contact_1': '',
      'contact_2': '',
      'diagnosis_one': '',
      'diagnosis_two': '',
      'gender_id': '',
      'medic': '',
      'priority': '',
      'program': '',
      'race': '',
      'start_date': '',
      'userId': userId,
      'zone': 0,
    });
  }

  /// Deletes a patient entry with the corresponding name.
  static deletePatient(String name) async {
    await patientCollection.deleteOne({'name': name});
  }

  /// Deletes a user entry with the corresponding name.
  static deleteUser(String name) async {
    await userCollection.deleteOne({'name': name});
  }

  /// Testing only
  /*
  static dropTest() async {
    await db.dropCollection('patients');
    await db.dropCollection('users');
    patientCollection = db.collection('patients');
    userCollection = db.collection('users');
  }
  */

  /// Test database functions
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
    await cleanupDatabase();
  }
}