import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pitayaclinic/services/models.dart';

class DatabaseService {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('Users');

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
}
