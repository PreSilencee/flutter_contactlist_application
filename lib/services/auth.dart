import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_contactlist_application/models/MyUser.dart';

class AuthService {
  //initialize the auth service
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on FirebaseUser
  MyUser? _userFromFirebaseUser(User? user) {
    return user != null ? MyUser(uid: user.uid) : null;
  }

  Stream<MyUser?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  Future registerWithEmailandPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  getCurrentUserId() {
    User? user = _auth.currentUser;
    String uid = user!.uid;
    return uid;
  }

  getCurrentUserEmail() {
    User? user = _auth.currentUser;
    String? email = user!.email;
    return email;
  }
}
