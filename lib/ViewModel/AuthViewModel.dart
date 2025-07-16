

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tasky/service/firebaseAuthService.dart';


class AuthState {
  final bool isLoading;
  final String? errorMessage;
  final User? user; 
  final bool isLoggedin;
  // Hold the authenticated user object

  AuthState({
    this.isLoading = false,
    this.errorMessage,
    this.user,
    this.isLoggedin = false,
  });

  // Helper to create a copy with updated values
  AuthState copyWith({
    bool? isLoading,
    String? errorMessage,
    User? user,
    bool? isLoggedin,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      user: user ?? this.user,
      isLoggedin: isLoggedin ?? this.isLoggedin,
    );
  }
}






class AuthViewModel extends StateNotifier<AuthState> {
  final AuthService _authService; // Dependency on AuthService

  AuthViewModel(this._authService) : super(AuthState());

  // Sign up with email and password
  Future<void> signUp(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await _authService.signUp(email, password);
      state = state.copyWith(isLoading: false, user: user,isLoggedin: true);
      print('Sign up successful for ${user?.email}');
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'weak-password':
          message = 'The password provided is too weak.';
          break;
        case 'email-already-in-use':
          message = 'The account already exists for that email.';
          break;
        case 'invalid-email':
          message = 'The email address is not valid.';
          break;
        default:
          message = 'Sign up failed: ${e.message}';
      }
      state = state.copyWith(isLoading: false, errorMessage: message);
      print('Sign up failed: $message');
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      print('Sign up failed: $e');
    }
  }
  



Future<void> signIn(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await _authService.signIn(email, password);
      state = state.copyWith(isLoading: false, user: user,isLoggedin: true);
      print('Sign in successful for ${user?.email}');
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found for that email.';
          break;
        case 'wrong-password':
          message = 'Wrong password provided for that user.';
          break;
        case 'invalid-email':
          message = 'The email address is not valid.';
          break;
        case 'invalid-credential': // For newer Firebase Auth versions
          message = 'Invalid credentials. Please check your email and password.';
          break;
        default:
          message = 'Sign in failed: ${e.message}';
      }
      state = state.copyWith(isLoading: false, errorMessage: message);
      print('Sign in failed: $message');
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      print('Sign in failed: $e');
    }
  }






    Future<void> signOut() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _authService.signOut();
      state = state.copyWith(isLoading: false, user: null);
      print('Signed out successfully');
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      print('Sign out failed: $e');
    }
  }
  }

  final authViewModelProvider=StateNotifierProvider<AuthViewModel,AuthState>
  ((ref) {

final AuthService =ref.watch(authserviceprovider);
return AuthViewModel(AuthService);  });