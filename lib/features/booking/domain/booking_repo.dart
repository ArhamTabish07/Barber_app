import 'package:barber_app/features/home/user/domain/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BookingRepository {
  Stream<QuerySnapshot<Map<String, dynamic>>> watchAllBookings();

  Future<void> createBooking({
    required UserModel user,
    required String service,
    required String date,
    required String time,
  });

  Future<void> deleteBooking(String id);
}
