import 'package:example/login/login_logic.dart';
import 'package:example/login/login_state.dart';
import 'package:example/repository/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoginState', () {
    test('should create with default values', () {
      const state = LoginState();

      expect(state.user, isEmpty);
      expect(state.signedIn, isFalse);
      expect(state.isLoading, isFalse);
      expect(state.error, isNull);
      expect(state.isLoggedIn, isFalse);
    });

    test('should create with custom values', () {
      const state = LoginState(
        user: 'testuser',
        signedIn: true,
        isLoading: true,
        error: 'Test error',
      );

      expect(state.user, equals('testuser'));
      expect(state.signedIn, isTrue);
      expect(state.isLoading, isTrue);
      expect(state.error, equals('Test error'));
      expect(state.isLoggedIn, isTrue);
    });

    test('should copy with new values', () {
      const original = LoginState(
        user: 'original',
        signedIn: false,
        isLoading: false,
        error: null,
      );

      final copied = original.copyWith(
        user: 'updated',
        signedIn: true,
        isLoading: true,
        error: 'New error',
      );

      expect(copied.user, equals('updated'));
      expect(copied.signedIn, isTrue);
      expect(copied.isLoading, isTrue);
      expect(copied.error, equals('New error'));

      // Original should remain unchanged
      expect(original.user, equals('original'));
      expect(original.signedIn, isFalse);
    });

    test('should be equal when properties are the same', () {
      const state1 = LoginState(
        user: 'testuser',
        signedIn: true,
        isLoading: false,
        error: null,
      );

      const state2 = LoginState(
        user: 'testuser',
        signedIn: true,
        isLoading: false,
        error: null,
      );

      expect(state1, equals(state2));
    });

    test('should not be equal when properties differ', () {
      const state1 = LoginState(
        user: 'testuser',
        signedIn: true,
        isLoading: false,
        error: null,
      );

      const state2 = LoginState(
        user: 'different',
        signedIn: true,
        isLoading: false,
        error: null,
      );

      expect(state1, isNot(equals(state2)));
    });
  });

  group('LoginLogic', () {
    late AuthRepository authRepository;
    late LoginLogic loginLogic;

    setUp(() {
      authRepository = AuthRepository();
      loginLogic = LoginLogic(authRepository);
    });

    tearDown(() {
      loginLogic.dispose();
      authRepository.dispose();
    });

    test('should initialize with default state', () {
      expect(loginLogic.value, equals(const LoginState()));
      expect(loginLogic.value.user, isEmpty);
      expect(loginLogic.value.signedIn, isFalse);
      expect(loginLogic.value.isLoading, isFalse);
      expect(loginLogic.value.error, isNull);
    });

    test('should update state when repository user changes', () async {
      const username = 'testuser';

      // Login through repository
      await authRepository.login(username);

      // Logic should update its state
      expect(loginLogic.value.user, equals(username));
      expect(loginLogic.value.isLoading, isFalse);
    });

    test('should login successfully', () async {
      const username = 'testuser';

      // Verify initial state
      expect(loginLogic.value.signedIn, isFalse);
      expect(loginLogic.value.user, isEmpty);

      // Perform login
      await loginLogic.login(username);

      // Verify state after login
      expect(loginLogic.value.signedIn, isTrue);
      expect(loginLogic.value.user, equals(username));
      expect(loginLogic.value.isLoading, isFalse);
      expect(loginLogic.value.error, isNull);
    });

    test('should set loading state during login', () async {
      const username = 'testuser';
      bool wasLoading = false;

      // Listen for state changes
      loginLogic.addListener(() {
        if (loginLogic.value.isLoading) {
          wasLoading = true;
        }
      });

      // Perform login
      await loginLogic.login(username);

      // Verify loading state was set
      expect(wasLoading, isTrue);
      expect(loginLogic.value.isLoading,
          isFalse); // Should be false after completion
    });

    test('should handle login error', () async {
      // Create a mock repository that throws an error
      final mockRepo = _MockAuthRepository();
      final logic = LoginLogic(mockRepo);

      try {
        await logic.login('testuser');

        // Verify error state
        expect(logic.value.isLoading, isFalse);
        expect(logic.value.error, isNotNull);
        expect(logic.value.signedIn, isFalse);
      } finally {
        logic.dispose();
      }
    });

    test('should logout successfully', () async {
      const username = 'testuser';

      // Login first
      await loginLogic.login(username);
      expect(loginLogic.value.signedIn, isTrue);
      expect(loginLogic.value.user, equals(username));

      // Logout
      loginLogic.logout();

      // Verify logout state
      expect(loginLogic.value.signedIn, isFalse);
      expect(authRepository.currentUser.value, isEmpty);
    });

    test('should handle multiple rapid login attempts', () async {
      const users = ['user1', 'user2', 'user3'];

      // Start multiple login attempts
      final futures = users.map((user) => loginLogic.login(user)).toList();

      // Wait for all to complete
      await Future.wait(futures);

      // Should be in a valid final state
      expect(loginLogic.value.isLoading, isFalse);
      expect(loginLogic.value.signedIn, isTrue);
      expect(users, contains(loginLogic.value.user));
    });
  });
}

/// Mock AuthRepository that throws errors for testing
class _MockAuthRepository extends AuthRepository {
  @override
  Future<void> login(String username) async {
    await Future.delayed(const Duration(milliseconds: 100));
    throw Exception('Mock login error');
  }
}
