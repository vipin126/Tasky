import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;

  AuthService(this._firebaseAuth);

 
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();


  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  // Sign up with email and password
  Future<User?> signUp(String email, String password) async {
    print('Attempting to sign up with email: $email');
    try {
      UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('Sign up successful for user: ${result.user?.email}');
      return result.user;
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException during sign up: ${e.code}');
     
      throw e;
    } catch (e) {
      
      throw Exception('An unexpected error occurred during sign up: $e');
    }
  }


  Future<User?> signIn(String email, String password) async {
    try {
      print('Attempting to sign in with email: $email');
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('Sign in successful for user: ${result.user?.email}');
      return result.user;
    } on FirebaseAuthException catch (e) {
      // Re-throw the specific Firebase Auth exception for UI to handle
      print('FirebaseAuthException during sign in: ${e.code}');
      throw e;
    } catch (e) {
      // Catch any other general exceptions
      throw Exception('An unexpected error occurred during sign in: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}

final authserviceprovider =Provider<AuthService>((ref){

return AuthService(FirebaseAuth.instance);

});