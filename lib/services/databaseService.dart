import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pitayaclinic/services/models.dart';

class DatabaseService {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('Users');

  final CollectionReference descriptionCollection =
      FirebaseFirestore.instance.collection('Descriptions');

  final String uid;

  DatabaseService({required this.uid});

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
      howtoidentify: snapshot['howtoidentify'] ?? '',
      cause: snapshot['cause'] ?? '',
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
        whyandwhereoccurs: document.get('whyandwhereoccurs'),
        howtomanage: document.get('howtomanage'),
        lastupdate: document.get('lastupdate'),
      );
    }).toList();
  }

  Stream<List<Descriptions>> get alldescriptions {
    return descriptionCollection.snapshots().map(_alldescriptions);
  }
}
