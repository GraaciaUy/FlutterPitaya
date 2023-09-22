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