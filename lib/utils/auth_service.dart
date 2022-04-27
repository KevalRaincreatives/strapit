import 'package:firebase_auth/firebase_auth.dart';
import 'package:strapit/utils/database_service.dart';
import 'package:strapit/utils/userss.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;


  // create user object based on FirebaseUser
  Userss? _userFromFirebaseUser(User? user) {
    return (user != null) ? Userss(uid: user.uid) : null;
  }


  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential? result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  Future signInWithEmailAndPassword2(String email, String password) async {
    try {
      UserCredential? result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return e.toString();
    }
  }


  // register with email and password
  Future registerWithEmailAndPassword(String fullName, String email, String password) async {
    try {
      UserCredential? result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      // Create a new document for the user with uid
      await DatabaseService(uid: user!.uid).updateUserData(fullName, email, password,"Visitors");
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return e.toString();
    }
  }

  //sign out
  // Future signOut() async {
  //   try {
  //     await HelperFunctions.saveUserLoggedInSharedPreference(false);
  //     await HelperFunctions.saveUserEmailSharedPreference('');
  //     await HelperFunctions.saveUserNameSharedPreference('');
  //
  //     return await _auth.signOut().whenComplete(() async {
  //       print("Logged out");
  //       await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
  //         print("Logged in: $value");
  //       });
  //       await HelperFunctions.getUserEmailSharedPreference().then((value) {
  //         print("Email: $value");
  //       });
  //       await HelperFunctions.getUserNameSharedPreference().then((value) {
  //         print("Full Name: $value");
  //       });
  //     });
  //   } catch(e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }
}