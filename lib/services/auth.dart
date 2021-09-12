import 'package:brew_crew/models/userAnon.dart';
import 'package:brew_crew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserAnon? _userFromFirebaseUer(User? user) {
    return user != null ? UserAnon(uid: user.uid) : null;
  }

  Stream<UserAnon?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUer);
  }

  // Sign In with Anonymous
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUer(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign In with Email and Password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUer(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Register with Email and Password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      // create new document for the user with uid
      await DatabaseService(uid: user!.uid)
          .updateUserData("0", "new crew member", 100);
      return _userFromFirebaseUer(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign Out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
