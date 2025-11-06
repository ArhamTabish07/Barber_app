import 'dart:developer';
import 'package:barber_app/domain/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  Database()
    : _firestore = FirebaseFirestore.instance,
      _usersCollection = FirebaseFirestore.instance.collection('users'),
      _bookingCollection = FirebaseFirestore.instance.collection('Booking');

  // ignore: unused_field
  final FirebaseFirestore _firestore;
  final CollectionReference _usersCollection;
  final CollectionReference<Map<String, dynamic>> _bookingCollection;

  Future<bool> addUserDetails(UserModel user) async {
    await _usersCollection
        .doc(user.uid)
        .set(user.toMap(), SetOptions(merge: true));
    return true;
  }

  Future<UserModel> getUserDetails({required String uid}) async {
    final docSnap = await _usersCollection.doc(uid).get();

    if (!docSnap.exists) {
      log("getUserDetails: no user doc for uid=$uid");
      return UserModel(uid: uid, email: '', name: '', image: '');
    }

    final data = docSnap.data() as Map<String, dynamic>;
    final user = UserModel.fromMap(data);

    log(
      "User fetched => uid=${user.uid}, name=${user.name}, email=${user.email}",
    );
    return user;
  }

  Future<void> addUserBooking(Map<String, dynamic> bookingData) async {
    await _bookingCollection.add(bookingData);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getBookings() {
    return _bookingCollection.snapshots();
  }

  Future<void> deleteBooking(String id) async {
    await _bookingCollection.doc(id).delete();
  }
}
