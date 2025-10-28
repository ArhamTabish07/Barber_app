import 'package:barber_app/data/repo_impl/booking_repo_impl.dart';
import 'package:barber_app/domain/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class BookingProvider extends ChangeNotifier {
  final BookingRepositoryImpl _repo;

  BookingProvider({BookingRepositoryImpl? repo})
    : _repo = repo ?? BookingRepositoryImpl();

  Stream<QuerySnapshot<Map<String, dynamic>>> get stream {
    return _repo.watchAllBookings();
  }

  Future<void> createBooking({
    required UserModel user,
    required String service,
    required String date,
    required String time,
  }) {
    return _repo.createBooking(
      user: user,
      service: service,
      date: date,
      time: time,
    );
  }

  Future<void> delete(String id) {
    return _repo.deleteBooking(id);
  }
}
