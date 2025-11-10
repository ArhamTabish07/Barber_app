import 'package:barber_app/features/home/user/domain/user_repo.dart';
import 'package:flutter/foundation.dart';

import 'package:barber_app/features/home/user/domain/user_model.dart';

class UserProvider extends ChangeNotifier {
  final UserRepository _repo;

  UserProvider({required UserRepository repo}) : _repo = repo;

  UserModel _currentUser = UserModel.empty();
  UserModel get currentUser => _currentUser;

  bool _loading = false;
  bool get isLoading => _loading;

  // Future<void> loadUserByUid(String uid) async {
  //   _loading = true;
  //   notifyListeners();
  //   if (uid.isEmpty) {
  //     _currentUser = UserModel.empty();
  //     _loading = false;
  //     notifyListeners();
  //     return;
  //   }
  //   final user = await _repo.getUser(uid);
  //   _currentUser = user;
  //   _loading = false;
  //   notifyListeners();
  // }

  Future<void> loadUser() async {
    _loading = true;
    notifyListeners();
    final uid = _repo.currentUid();
    if (uid == null || uid.isEmpty) {
      _currentUser = UserModel.empty();
      _loading = false;
      notifyListeners();
      return;
    }
    final user = await _repo.getUser(uid);
    _currentUser = user;
    _loading = false;
    notifyListeners();
  }

  void setUser(UserModel user) {
    _currentUser = user;
    notifyListeners();
  }

  void clearUser() {
    _currentUser = UserModel.empty();
    notifyListeners();
  }
}
