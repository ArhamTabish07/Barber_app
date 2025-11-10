import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';

class FirebaseExceptionHandler {
  static String handleException(Exception e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'invalid-email':
          return 'The email address is invalid. Please check and try again.';
        case 'user-disabled':
          return 'This user has been disabled. Please contact support.';
        case 'user-not-found':
          return 'No user found for this email.';
        case 'wrong-password':
          return 'Incorrect password. Please try again.';
        case 'email-already-in-use':
          return 'The email address is already in use by another account.';
        case 'operation-not-allowed':
          return 'This operation is not allowed. Please contact support.';
        case 'weak-password':
          return 'The password provided is too weak.';
        case 'password-too-short':
          return 'The password is too short. It must be at least 6 characters long.';
        case 'password-too-common':
          return 'The password is too common. Please choose a stronger password.';
        case 'password-has-numeric':
          return 'The password must contain at least one number.';
        case 'password-has-uppercase':
          return 'The password must contain at least one uppercase letter.';
        case 'password-has-special-char':
          return 'The password must contain at least one special character (e.g., @, #, \$, %).';

        case 'network-request-failed':
          return 'Network error. Please check your connection and try again.';
        case 'too-many-requests':
          return 'Too many attempts. Please try again later.';
        case 'requires-recent-login':
          return 'You need to reauthenticate to perform this operation.';
        case 'credential-already-in-use':
          return 'The credentials provided are already in use by another account.';
        case 'account-exists-with-different-credential':
          return 'An account already exists with the same email address but different credentials.';
        case 'unknown':
          return 'Connection error. Please check your internet and try again.';
        default:
          return 'An unexpected error occurred: ${e.message ?? 'Unknown error'}';
      }
    } else if (e is FirebaseException) {
      return 'Firebase error: ${e.message ?? 'Unknown error'}';
    } else {
      log('Unhandled exception: $e');
      return 'An unexpected error occurred. Please try again.';
    }
  }
}
