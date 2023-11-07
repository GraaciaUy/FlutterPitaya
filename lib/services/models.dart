import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  String uid;
  String firstname;
  String lastname;
  String email;
  Timestamp userCreated;

  UserData(
      {required this.uid,
      required this.firstname,
      required this.lastname,
      required this.email,
      required this.userCreated});
}

class Descriptions {
  String uid;
  String howtoidentify;
  String cause;
  String whyandwhereoccurs;
  String howtomanage;
  String name;
  String category;
  String uiname;
  String photo;
  Timestamp lastupdate;

  Descriptions({
    required this.uid,
    required this.howtoidentify,
    required this.cause,
    required this.category,
    required this.uiname,
    required this.photo,
    required this.whyandwhereoccurs,
    required this.howtomanage,
    required this.name,
    required this.lastupdate,
  });
}

class ResultsData {
  String uid;
  String detected;
  String photo;
  Timestamp timeCreated;

  ResultsData(
      {required this.uid,
      required this.detected,
      required this.photo,
      required this.timeCreated});
}
