import 'package:flutter/foundation.dart';

/// Simple auth repository to demonstrate shared state
class AuthRepository {
  AuthRepository() : _currentUser = ValueNotifier('');

  final ValueNotifier<String> _currentUser;

  /// Current user state
  ValueListenable<String> get currentUser => _currentUser;

  /// Login with username
  Future<void> login(String username) async {
    // Simulate network call
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser.value = username;
  }

  /// Logout
  void logout() {
    _currentUser.value = '';
  }

  void dispose() {
    _currentUser.dispose();
  }
}
