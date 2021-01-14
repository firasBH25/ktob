import 'package:bookini/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'database.dart';

class AuthService {
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // create Myuser obj based on firebase user
  MyUser _userFromFirebaseUser(User user) {
    return user != null ? MyUser(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<MyUser> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }


  // sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      return user;
    } catch (error) {
      return null;
    } 
  }
  

  // register with email and password
  Future registerWithEmailAndPassword(String email, String password  ,String userName) async {
    try {
      
      //create user 
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      //create user's data
      await DatabaseService(uid: user.uid).updakteUserData("Bookini User", "UnKnown", "" , "" ,userName);
      return _userFromFirebaseUser(user);
            
    } catch (error) {
      return null;
    } 
  }
  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // update user profile 
  Future updateProfile(String fullname,String location, String phone ,String bio ) async {
    try {
      await DatabaseService(uid: _auth.currentUser.uid).updakteUserData(fullname, location, phone , bio,'');
      return _userFromFirebaseUser(_auth.currentUser);
    } catch (error) {
      print(error.toString());
      return null;
    } 
  }
  

}