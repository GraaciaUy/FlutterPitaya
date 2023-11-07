import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pitayaclinic/services/models.dart';

class DatabaseService {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('Users');

  final CollectionReference resultsCollection =
      FirebaseFirestore.instance.collection('Results');

  final CollectionReference descriptionCollection =
      FirebaseFirestore.instance.collection('Descriptions');

  final String uid;

  DatabaseService({required this.uid});

  Future<bool> insertResult(uid, photo, detected) async {
    try {
      resultsCollection.add({
        'uid': uid,
        'detected': detected,
        'photo': photo,
        'timeCreated': DateTime.now(),
      });
      return true;
    } on FirebaseAuthException {
      return false;
    }
  }

  UserData _getUserData(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      firstname: snapshot['firstname'] ?? '',
      lastname: snapshot['lastname'] ?? '',
      email: snapshot['email'] ?? '',
      userCreated: snapshot['userCreated'] ?? '',
    );
  }

  Stream<UserData> get userData {
    return userCollection.doc(uid).snapshots().map(_getUserData);
  }

  Descriptions _getDescription(DocumentSnapshot snapshot) {
    return Descriptions(
      uid: snapshot['uid'] ?? '',
      howtoidentify: snapshot['howtoidentify'] ?? '',
      cause: snapshot['cause'] ?? '',
      category: snapshot['category'] ?? '',
      uiname: snapshot['uiname'] ?? '',
      photo: snapshot['photo'] ?? '',
      whyandwhereoccurs: snapshot['whyandwhereoccurs'] ?? '',
      howtomanage: snapshot['howtomanage'] ?? '',
      name: snapshot['name'] ?? '',
      lastupdate: snapshot['lastupdate'] ?? '',
    );
  }

  Stream<Descriptions> get descriptionData {
    return userCollection.doc(uid).snapshots().map(_getDescription);
  }

  List<Descriptions> _alldescriptions(QuerySnapshot snapshot) {
    return snapshot.docs.map((document) {
      return Descriptions(
        howtoidentify: document.get('howtoidentify'),
        cause: document.get('cause'),
        name: document.get('name'),
        category: document.get('category'),
        uiname: document.get('uiname'),
        photo: document.get('photo'),
        whyandwhereoccurs: document.get('whyandwhereoccurs'),
        howtomanage: document.get('howtomanage'),
        lastupdate: document.get('lastupdate'),
        uid: document.get('uid'),
      );
    }).toList();
  }

  Stream<List<Descriptions>> get alldescriptions {
    return descriptionCollection.snapshots().map(_alldescriptions);
  }

  List<ResultsData> _resutlsUser(QuerySnapshot snapshot) {
    return snapshot.docs.map((document) {
      return ResultsData(
        uid: document.get('uid'),
        detected: document.get('detected'),
        photo: document.get('photo'),
        timeCreated: document.get('timeCreated'),
      );
    }).toList();
  }

  Stream<List<ResultsData>> get getuserResults {
    return resultsCollection
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map(_resutlsUser);
  }
}
