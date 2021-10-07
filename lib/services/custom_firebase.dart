import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project1/models/current_user_model.dart';
import 'package:project1/services/custom_firestore.dart';

class CustomFirebase with ChangeNotifier {
  // singleton class
  CustomFirebase._();
  static final instance = CustomFirebase._();

  bool? isRounded = false;

  // instance of custom Firestore class
  final _store = CustomFireStore.instance;

  // instance of firebase auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // creating a string variable and a getter to stored errors incase it happens
  String _errorMess = '';
  String get errorMess => _errorMess;

  // google sign-in Authentication method
  Future googleSignIn(BuildContext contxt) async {
    final GoogleSignIn _googleAuth = GoogleSignIn();
    final GoogleSignInAccount? _googleSignInAccount =
        await _googleAuth.signIn();

    if (_googleSignInAccount != null) {
      final GoogleSignInAuthentication _googleAuthIn =
          await _googleSignInAccount.authentication;
      try {
        final AuthCredential _firebaseAuth = GoogleAuthProvider.credential(
          accessToken: _googleAuthIn.accessToken,
          idToken: _googleAuthIn.idToken,
        );
        UserCredential _firebaseUserCredential =
            await _auth.signInWithCredential(_firebaseAuth);
        User? _user = _firebaseUserCredential.user;
        // checking if the user is null, if not his/her
        //credential will be stored to shared pref
        if (_user != null) {
          Map<String, dynamic> userInfoData = {
            'userId': _auth.currentUser!.uid,
            'email': _user.email,
            'photoUrl': _user.photoURL,
            'displayName': _user.displayName,
            'status': [],
          };
          _store.dataToFirestore(_user.uid, userInfoData);
          return _user;
        }
      } on FirebaseAuthException catch (e) {
        _errorMess = e.message.toString();
        notifyListeners();
      }
    }
  }

  // creating new account with email and password
  Future createAccoutWithEmailAndPassword({
    required String email,
    required String password,
    required String userName,
  }) async {
    try {
      UserCredential _userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? _user = _userCredential.user;
      if (_user != null) {
        Map<String, dynamic> userInfoData = {
          'userId': _auth.currentUser!.uid,
          'email': _user.email,
          'photoUrl': _user.photoURL,
          'displayName': userName,
          'status': [],
        };
        await _user.updateDisplayName(userName);
        _store.dataToFirestore(_user.uid, userInfoData);
        return _user;
      }
    } on FirebaseAuthException catch (e) {
      _errorMess = e.message.toString();
    }
  }

  // profile picture link
  Future updatinguserProfile(String imageUrl) async {
    await _auth.currentUser?.updatePhotoURL(imageUrl);
    await _store.updateProfile(_auth.currentUser!.uid, imageUrl);
  }

  // profile username link
  Future updatinguserName(String name) async {
    await _auth.currentUser?.updateDisplayName(name);
    await _store.updateName(_auth.currentUser!.uid, name);
  }

  // signIng in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential _userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? _user = _userCredential.user;
      return _user;
    } on FirebaseAuthException catch (e) {
      _errorMess = e.message.toString();
    }
  }

  // sign Out Method
  Future signOut() async {
    try {
      return await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      _errorMess = e.message.toString();
    }
  }

  // Switch TileList function
  Widget customSwitch() {
    return Switch.adaptive(
      activeColor: Colors.white,
      autofocus: true,
      value: isRounded!,
      onChanged: (val) {
        isRounded = val;
        notifyListeners();
      },
    );
  }

  CurrentUserModel? _userModel(User? user) {
    return user != null
        ? CurrentUserModel(
            displayName: user.displayName,
            photoUrl: user.photoURL,
            email: user.email,
            userId: user.uid,
          )
        : null;
  }

  Stream<CurrentUserModel?> get currentUser {
    return _auth.authStateChanges().map(_userModel);
  }
}
