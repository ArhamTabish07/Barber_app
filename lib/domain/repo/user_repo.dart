import 'package:barber_app/domain/models/user_model.dart';
import 'dart:typed_data';

abstract class UserRepository {
  Future<String> createAccountAndReturnUid({
    required String email,
    required String password,
  });

  Future<void> signIn({required String email, required String password});

  String? currentUid();

  Future<void> saveUser(UserModel user);

  Future<UserModel> getUser(String uid);

  String avatarFromBytes(Uint8List? bytes);
}
