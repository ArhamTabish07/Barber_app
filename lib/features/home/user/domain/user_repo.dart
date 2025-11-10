import 'package:barber_app/features/home/user/domain/user_model.dart';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';

abstract class UserRepository {
  Future<String> createAccountAndReturnUid({
    required String email,
    required String password,
  });

  Future<UserCredential?> signIn({
    required String email,
    required String password,
  });

  String? currentUid();

  Future<void> saveUser(UserModel user);

  Future<UserModel> getUser(String uid);

  String avatarFromBytes(Uint8List? bytes);

  /// Fetch admin document by id. Returns null if not found.
  Future<Map<String, dynamic>?> getAdminById(String id);
}
