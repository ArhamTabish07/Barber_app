import 'package:barber_app/domain/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingRemoteDataSource {
  final FirebaseFirestore _firestore;

  BookingRemoteDataSource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> watchAllBookings() {
    return _firestore.collection('Bookings').snapshots();
  }

  Future<void> createBooking({
    required UserModel user,
    required String service,
    required String date,
    required String time,
  }) async {
    await _firestore.collection('Bookings').add({
      'Username': user.name.trim(),
      'Email': user.email.trim(),
      'Image': user.image.trim(), // base64 or ""
      'Service': service.trim(),
      'Date': date.trim(),
      'Time': time.trim(),
      'CreatedAt': DateTime.now().toIso8601String(),
    });
  }

  Future<void> deleteBooking(String id) async {
    await _firestore.collection('Bookings').doc(id).delete();
  }
}
