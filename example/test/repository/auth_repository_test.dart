import 'package:example/repository/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthRepository', () {
    late AuthRepository authRepository;

    setUp(() {
      authRepository = AuthRepository();
    });

    tearDown(() {
      authRepository.dispose();
    });

    test('should initialize with empty user', () {
      expect(authRepository.currentUser.value, isEmpty);
    });

    test('should login successfully with username', () async {
      const username = 'testuser';

      // Verify initial state
      expect(authRepository.currentUser.value, isEmpty);

      // Perform login
      await authRepository.login(username);

      // Verify user is logged in
      expect(authRepository.currentUser.value, equals(username));
    });

    test('should logout successfully', () async {
      const username = 'testuser';

      // Login first
      await authRepository.login(username);
      expect(authRepository.currentUser.value, equals(username));

      // Logout
      authRepository.logout();

      // Verify user is logged out
      expect(authRepository.currentUser.value, isEmpty);
    });

    test('should notify listeners when user changes', () async {
      const username = 'testuser';
      var notificationCount = 0;

      // Listen to changes
      authRepository.currentUser.addListener(() {
        notificationCount++;
      });

      // Login should trigger notification
      await authRepository.login(username);
      expect(notificationCount, equals(1));

      // Logout should trigger notification
      authRepository.logout();
      expect(notificationCount, equals(2));
    });

    test('should handle multiple login attempts', () async {
      const firstUser = 'user1';
      const secondUser = 'user2';

      // First login
      await authRepository.login(firstUser);
      expect(authRepository.currentUser.value, equals(firstUser));

      // Second login should replace first user
      await authRepository.login(secondUser);
      expect(authRepository.currentUser.value, equals(secondUser));
    });
  });
}
