import 'dart:developer';
import 'package:barber_app/features/Admin/admin_show_bookings.dart';
import 'package:barber_app/core/dependency_injection/di.dart';
import 'package:barber_app/core/services/navigation_service.dart';
import 'package:barber_app/features/home/user/domain/user_model.dart';
import 'package:barber_app/features/home/user/domain/user_repo.dart';
import 'package:barber_app/features/home/user/provider/user_provider.dart';
import 'package:barber_app/features/onboarding/screen/onboarding.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:barber_app/core/services/fire_base_error_handler.dart';

class AuthenticationProvider extends ChangeNotifier {
  final UserRepository userRepo;

  AuthenticationProvider({required this.userRepo});
  final _navService = DI.i<NavigationService>();
  final userProvider = DI.i<UserProvider>();

  // AuthenticationProvider({UserRepository userRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  Future<String?> signUp({
    required String name,
    required String email,
    required String password,
    Uint8List? imageBytes,
  }) async {
    _setLoading(true);
    try {
      if (FirebaseAuth.instance.currentUser != null) {
        await userProvider.loadUser();
        _navService.pushReplacementToScreen(nextScreen: Onboarding());
      }
      // 1. create FirebaseAuth user, get uid
      final uid = await userRepo.createAccountAndReturnUid(
        email: email,
        password: password,
      );

      // 2. turn picked bytes -> base64 string
      final avatarBase64 = userRepo.avatarFromBytes(imageBytes);

      // 3. create user model
      final model = UserModel(
        uid: uid,
        email: email,
        name: name,
        image: avatarBase64,
      );

      // 4. save to Firestore
      await userRepo.saveUser(model);

      return null; // success
    } on FirebaseException catch (e) {
      String? error = FirebaseExceptionHandler.handleException(e);
      log("Error on signup on Auth provider ${e}");
      _navService.showToast(error);
    } finally {
      _setLoading(false);
    }
    return null;
  }

  // SIGN IN
  Future<void> signIn({required String email, required String password}) async {
    _setLoading(true);
    try {
      final UserCredential? user = await userRepo.signIn(
        email: email,
        password: password,
      );
      if (user != null) {
        // final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
        await userProvider.loadUser();
        _navService.pushReplacementToScreen(nextScreen: Onboarding());
      } else {
        _navService.showToast("Invlid email or password");
      }
    } on FirebaseException catch (e) {
      String? error = FirebaseExceptionHandler.handleException(e);
      log("Error on signIn on Auth provider ${e}");
      _navService.showToast(error);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<String?> resetPassword({required String email}) async {
    _setLoading(true);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return null;
    } catch (e) {
      return FirebaseExceptionHandler.handleException(
        e is Exception ? e : Exception(e.toString()),
      );
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loginAdmin({
    required String id,
    required String password,
  }) async {
    _setLoading(true);
    try {
      final data = await userRepo.getAdminById(id.trim());
      if (data == null) {
        _navService.showToast('Your id is not correct');
        return;
      }
      final storedPassword = (data['password'] ?? '').toString();
      if (storedPassword != password.trim()) {
        _navService.showToast('Your password is not correct');
        return;
      }
      _navService.pushReplacementToScreen(nextScreen: AdminShowBookings());
    } on FirebaseException catch (e) {
      final error = FirebaseExceptionHandler.handleException(e);
      log("Error on loginAdmin on Auth provider $e");
      _navService.showToast(error);
    } finally {
      _setLoading(false);
    }
  }
}
