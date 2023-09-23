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
  String howtoidentify;
  String cause;
  String whyandwhereoccurs;
  String howtomanage;
  String name;
  Timestamp lastupdate;

  Descriptions({
    required this.howtoidentify,
    required this.cause,
    required this.whyandwhereoccurs,
    required this.howtomanage,
    required this.name,
    required this.lastupdate,
  });
}
