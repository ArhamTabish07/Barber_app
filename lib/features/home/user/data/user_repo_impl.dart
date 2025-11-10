import 'dart:typed_data';

import 'package:barber_app/features/home/user/data/user_remote_data_source.dart';
import 'package:barber_app/features/home/user/domain/user_model.dart';
import 'package:barber_app/features/home/user/domain/user_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _remote;

  UserRepositoryImpl({UserRemoteDataSource? remote})
    : _remote = remote ?? UserRemoteDataSource();

  @override
  Future<String> createAccountAndReturnUid({
    required String email,
    required String password,
  }) {
    return _remote.createAuthUser(email: email, password: password);
  }

  @override
  Future<UserCredential?> signIn({
    required String email,
    required String password,
  }) {
    return _remote.signInWithEmail(email: email, password: password);
  }

  @override
  String? currentUid() {
    return _remote.currentUid();
  }

  @override
  Future<void> saveUser(UserModel user) {
    return _remote.saveUser(user);
  }

  @override
  Future<UserModel> getUser(String uid) {
    return _remote.getUserByUid(uid);
  }

  @override
  String avatarFromBytes(Uint8List? bytes) {
    return _remote.encodeAvatar(bytes);
  }

  @override
  Future<Map<String, dynamic>?> getAdminById(String id) {
    return _remote.getAdminById(id);
  }
}
