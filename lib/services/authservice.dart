import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;

  AuthService(this._firebaseAuth);

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('Users');

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<bool> loginUser(email, pass) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: pass);
      return true;
    } on FirebaseAuthException {
      return false;
    }
  }

  Future<bool> registerUser(email, pass, firstname, lastname) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );

      // Access the user's credentials
      User? user = userCredential.user;

      String? uid = user?.uid;

      registerUserToCloudFirestore(email, firstname, lastname, uid);

      FirebaseAuth.instance.signOut();

      return true;
    } on FirebaseAuthException {
      return false;
    }
  }

  Future<bool> registerUserToCloudFirestore(
      email, firstname, lastname, uid) async {
    try {
      userCollection.doc(uid).set({
        'email': email,
        'firstname': firstname,
        'lastname': lastname,
        'userCreated': DateTime.now(),
      });
      return true;
    } on FirebaseAuthException {
      return false;
    }
  }

  // sign out user
  Future<bool> signout() async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } on FirebaseAuthException {
      return false;
    }
  }
}
