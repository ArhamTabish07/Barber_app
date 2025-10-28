import 'package:barber_app/data/datasource/booking_remote_data_soure.dart';
import 'package:barber_app/domain/models/user_model.dart';
import 'package:barber_app/domain/repo/booking_repo.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource _remote;

  BookingRepositoryImpl({BookingRemoteDataSource? remote})
    : _remote = remote ?? BookingRemoteDataSource();

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> watchAllBookings() {
    return _remote.watchAllBookings();
  }

  @override
  Future<void> createBooking({
    required UserModel user,
    required String service,
    required String date,
    required String time,
  }) {
    return _remote.createBooking(
      user: user,
      service: service,
      date: date,
      time: time,
    );
  }

  @override
  Future<void> deleteBooking(String id) {
    return _remote.deleteBooking(id);
  }
}
