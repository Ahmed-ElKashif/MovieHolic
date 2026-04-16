import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authprovider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Use the new v7 singleton instance
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  bool _isGoogleInitialized = false;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Real Firebase Login
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      _isLoading = false;
      notifyListeners();
      return true; // Success!
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase Auth Error: ${e.message}');
      _isLoading = false;
      notifyListeners();
      return false; // Failed
    } catch (e) {
      debugPrint("Login failed: $e");
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Google Sign-In (Updated for v7.x)
  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    notifyListeners();

    try {
      // You MUST initialize the instance exactly once before using it
      if (!_isGoogleInitialized) {
        await _googleSignIn.initialize();
        _isGoogleInitialized = true;
      }

      // .authenticate() throws an error if canceled.
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          googleUser.authentication;

      // -------------------------------------------------------------
      // FIX: Create a new credential for Firebase
      // In v7, we ONLY pass the idToken. Firebase doesn't need an accessToken!
      // -------------------------------------------------------------
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase using this credential
      await _auth.signInWithCredential(credential);

      _isLoading = false;
      notifyListeners();
      return true; // Success!
    } on GoogleSignInException catch (e) {
      debugPrint('Google Sign-In Canceled: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      debugPrint('Google Sign-In Error: $e');
      _isLoading = false;
      notifyListeners();
      return false; // Failed
    }
  }

  // Real Firebase Logout
  Future<void> logout() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
