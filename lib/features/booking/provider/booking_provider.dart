import 'package:barber_app/features/booking/domain/booking_repo.dart';
import 'package:barber_app/core/services/fire_base_error_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:barber_app/features/home/user/domain/user_model.dart';

class BookingProvider extends ChangeNotifier {
  final BookingRepository _repo;

  BookingProvider({required BookingRepository repo}) : _repo = repo;

  Stream<QuerySnapshot<Map<String, dynamic>>> get stream =>
      _repo.watchAllBookings();

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  Future<void> createBooking({
    required UserModel user,
    required String service,
    required String date,
    required String time,
  }) {
    _isSubmitting = true;
    notifyListeners();
    return _repo
        .createBooking(user: user, service: service, date: date, time: time)
        .whenComplete(() {
          _isSubmitting = false;
          notifyListeners();
        });
  }

  Future<String?> delete(String id) async {
    try {
      await _repo.deleteBooking(id);
      return null;
    } catch (e) {
      return FirebaseExceptionHandler.handleException(
        e is Exception ? e : Exception(e.toString()),
      );
    }
  }
}
