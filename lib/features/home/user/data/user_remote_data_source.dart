import 'package:barber_app/features/home/user/domain/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'dart:typed_data';

class UserRemoteDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  UserRemoteDataSource({FirebaseAuth? auth, FirebaseFirestore? firestore})
    : _auth = auth ?? FirebaseAuth.instance,
      _firestore = firestore ?? FirebaseFirestore.instance;

  /// Create FirebaseAuth account and return uid
  Future<String> createAuthUser({
    required String email,
    required String password,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred.user!.uid;
  }

  /// Sign in existing user
  // Future<UserCredential?> signInWithEmail({
  //   required String email,
  //   required String password,
  // }) async {
  //   try {
  //     UserCredential result = await _auth.signInWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //     return result;
  //   } catch (e) {
  //     return null;
  //   }
  // }

  /// Sign in existing user
  Future<UserCredential?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  /// Return current auth uid or null
  String? currentUid() {
    return _auth.currentUser?.uid;
  }

  /// Save user document in Firestore
  Future<void> saveUser(UserModel user) async {
    // we'll store under "Users/<uid>"
    await _firestore.collection('Users').doc(user.uid).set(user.toMap());
  }

  /// Get user document from Firestore
  Future<UserModel> getUserByUid(String uid) async {
    final snap = await _firestore.collection('Users').doc(uid).get();
    if (!snap.exists) {
      return UserModel.empty();
    }
    final data = snap.data() ?? {};
    return UserModel.fromMap(data);
  }

  /// Helper to build base64 string from bytes (for avatar)
  String encodeAvatar(Uint8List? bytes) {
    if (bytes == null || bytes.isEmpty) return '';
    return base64Encode(bytes);
  }

  /// Fetch an admin document by `id` field from `Admin` collection
  Future<Map<String, dynamic>?> getAdminById(String id) async {
    final snap = await _firestore
        .collection('Admin')
        .where('id', isEqualTo: id)
        .limit(1)
        .get();
    if (snap.docs.isEmpty) return null;
    return snap.docs.first.data();
  }
}
