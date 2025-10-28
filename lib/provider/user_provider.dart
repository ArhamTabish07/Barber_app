import 'package:barber_app/data/repo_impl/user_repo_impl.dart';
import 'package:barber_app/domain/models/user_model.dart';
import 'package:flutter/foundation.dart';

class UserProvider extends ChangeNotifier {
  final UserRepositoryImpl _repo;

  UserProvider({UserRepositoryImpl? repo})
    : _repo = repo ?? UserRepositoryImpl();

  UserModel _currentUser = UserModel.empty();
  UserModel get currentUser => _currentUser;

  Future<void> loadUserByUid(String uid) async {
    if (uid.isEmpty) {
      _currentUser = UserModel.empty();
      notifyListeners();
      return;
    }

    final user = await _repo.getUser(uid);
    _currentUser = user;
    notifyListeners();
  }

  Future<void> loadUser() async {
    final uid = _repo.currentUid();
    if (uid == null || uid.isEmpty) {
      _currentUser = UserModel.empty();
      notifyListeners();
      return;
    }

    final user = await _repo.getUser(uid);
    _currentUser = user;
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
