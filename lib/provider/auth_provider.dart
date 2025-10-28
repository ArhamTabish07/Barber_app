import 'dart:typed_data';
import 'package:barber_app/data/repo_impl/user_repo_impl.dart';
import 'package:barber_app/domain/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationProvider extends ChangeNotifier {
  final UserRepositoryImpl _userRepo;

  AuthenticationProvider({UserRepositoryImpl? userRepo})
    : _userRepo = userRepo ?? UserRepositoryImpl();

  // SIGN UP: returns error string or null if success
  Future<String?> signUp({
    required String name,
    required String email,
    required String password,
    Uint8List? imageBytes,
  }) async {
    try {
      // 1. create FirebaseAuth user, get uid
      final uid = await _userRepo.createAccountAndReturnUid(
        email: email,
        password: password,
      );

      // 2. turn picked bytes -> base64 string
      final avatarBase64 = _userRepo.avatarFromBytes(imageBytes);

      // 3. create user model
      final model = UserModel(
        uid: uid,
        email: email,
        name: name,
        image: avatarBase64,
      );

      // 4. save to Firestore
      await _userRepo.saveUser(model);

      return null; // success
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'Password is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'That email is already registered.';
      } else {
        return e.message ?? 'Sign up failed.';
      }
    } catch (_) {
      return 'Something went wrong. Please try again.';
    }
  }

  // SIGN IN
  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _userRepo.signIn(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password.';
      } else {
        return e.message ?? 'Sign in failed.';
      }
    } catch (_) {
      return 'Something went wrong. Please try again.';
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<String?> resetPassword({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found with that email.';
      } else if (e.code == 'invalid-email') {
        return 'That email address is not valid.';
      } else {
        return e.message ?? 'Could not send reset email.';
      }
    } catch (_) {
      return 'Something went wrong. Please try again.';
    }
  }
}
