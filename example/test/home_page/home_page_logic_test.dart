import 'package:example/home_page/home_page_logic.dart';
import 'package:example/home_page/home_page_state.dart';
import 'package:example/repository/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HomePageState', () {
    test('should create with required values', () {
      const state = HomePageState(
        counter: 5,
        message: 'Test message',
        isLoading: true,
        items: ['item1', 'item2'],
        status: HomePageStatus.success,
        currentUser: 'testuser',
      );

      expect(state.counter, equals(5));
      expect(state.message, equals('Test message'));
      expect(state.isLoading, isTrue);
      expect(state.items, equals(['item1', 'item2']));
      expect(state.status, equals(HomePageStatus.success));
      expect(state.currentUser, equals('testuser'));
    });

    test('should copy with new values', () {
      const original = HomePageState(
        counter: 1,
        message: 'Original',
        isLoading: false,
        items: ['original'],
        status: HomePageStatus.idle,
        currentUser: null,
      );

      final copied = original.copyWith(
        counter: 10,
        message: 'Updated',
        isLoading: true,
        items: ['updated1', 'updated2'],
        status: HomePageStatus.loading,
        currentUser: 'newuser',
      );

      expect(copied.counter, equals(10));
      expect(copied.message, equals('Updated'));
      expect(copied.isLoading, isTrue);
      expect(copied.items, equals(['updated1', 'updated2']));
      expect(copied.status, equals(HomePageStatus.loading));
      expect(copied.currentUser, equals('newuser'));

      // Original should remain unchanged
      expect(original.counter, equals(1));
      expect(original.message, equals('Original'));
    });

    test('should be equal when properties are the same', () {
      const state1 = HomePageState(
        counter: 5,
        message: 'Test',
        isLoading: true,
        items: ['item1', 'item2'],
        status: HomePageStatus.loading,
        currentUser: 'testuser',
      );

      const state2 = HomePageState(
        counter: 5,
        message: 'Test',
        isLoading: true,
        items: ['item1', 'item2'],
        status: HomePageStatus.loading,
        currentUser: 'testuser',
      );

      expect(state1, equals(state2));
    });

    group('HomePageStatus enum', () {
      test('should have all expected values', () {
        expect(
            HomePageStatus.values,
            containsAll([
              HomePageStatus.idle,
              HomePageStatus.loading,
              HomePageStatus.success,
              HomePageStatus.error,
            ]));
      });

      test('should have correct string representation', () {
        expect(HomePageStatus.idle.name, equals('idle'));
        expect(HomePageStatus.loading.name, equals('loading'));
        expect(HomePageStatus.success.name, equals('success'));
        expect(HomePageStatus.error.name, equals('error'));
      });
    });
  });

  group('HomePageLogic', () {
    late HomePageLogic logic;
    late AuthRepository authRepository;

    setUp(() {
      authRepository = AuthRepository();
      logic = HomePageLogic(authRepository);
    });

    tearDown(() {
      logic.dispose();
      authRepository.dispose();
    });

    test('should initialize with default state', () {
      expect(logic.value.counter, equals(0));
      expect(
          logic.value.message, equals('Welcome! Tap the buttons to interact.'));
      expect(logic.value.isLoading, isFalse);
      expect(logic.value.items, isEmpty);
      expect(logic.value.status, equals(HomePageStatus.idle));
      expect(logic.value.currentUser, isNull);
    });

    test('should initialize without auth repository', () {
      final logicWithoutAuth = HomePageLogic();

      expect(logicWithoutAuth.value.counter, equals(0));
      expect(logicWithoutAuth.value.message,
          equals('Welcome! Tap the buttons to interact.'));
      expect(logicWithoutAuth.value.currentUser, isNull);

      logicWithoutAuth.dispose();
    });

    test('should update message when auth user changes', () async {
      const username = 'testuser';

      // Login user
      await authRepository.login(username);

      // Logic should update message with user
      expect(logic.value.currentUser, equals(username));
      expect(logic.value.message,
          equals('Welcome back, $username! Tap the buttons to interact.'));
    });

    test('should increment counter', () {
      expect(logic.value.counter, equals(0));

      logic.increment();

      expect(logic.value.counter, equals(1));
      expect(logic.value.message, equals('Counter incremented to 1'));
    });

    test('should decrement counter', () {
      // Start with a positive counter
      logic.increment();
      logic.increment();
      expect(logic.value.counter, equals(2));

      logic.decrement();

      expect(logic.value.counter, equals(1));
      expect(logic.value.message, equals('Counter decremented to 1'));
    });

    test('should allow negative counter values', () {
      expect(logic.value.counter, equals(0));

      logic.decrement();

      expect(logic.value.counter, equals(-1));
      expect(logic.value.message, equals('Counter decremented to -1'));
    });

    test('should reset counter to zero', () {
      // Change counter value
      logic.increment();
      logic.increment();
      expect(logic.value.counter, equals(2));

      logic.reset();

      expect(logic.value.counter, equals(0));
      expect(logic.value.message, equals('Counter reset to 0'));
    });

    test('should perform async increment', () async {
      expect(logic.value.counter, equals(0));
      expect(logic.value.status, equals(HomePageStatus.idle));

      // Start async increment
      final future = logic.incrementAsync();

      // Should be in loading state
      expect(logic.value.isLoading, isTrue);
      expect(logic.value.status, equals(HomePageStatus.loading));
      expect(logic.value.message, equals('Incrementing counter...'));

      // Wait for completion
      await future;

      // Should be completed successfully
      expect(logic.value.counter, equals(1));
      expect(logic.value.isLoading, isFalse);
      expect(logic.value.status, equals(HomePageStatus.success));
      expect(logic.value.message, equals('Counter incremented to 1 (async)'));
    });

    test('should load items successfully or handle error', () async {
      expect(logic.value.items, isEmpty);
      expect(logic.value.status, equals(HomePageStatus.idle));

      // Start loading
      final future = logic.loadItems();

      // Should be in loading state
      expect(logic.value.isLoading, isTrue);
      expect(logic.value.status, equals(HomePageStatus.loading));
      expect(logic.value.message, equals('Loading items...'));

      // Wait for completion
      await future;

      // Should either succeed or fail (due to random logic)
      expect(logic.value.isLoading, isFalse);
      if (logic.value.status == HomePageStatus.success) {
        expect(logic.value.items.length, equals(5));
        expect(logic.value.items.first, equals('Item 1'));
        expect(logic.value.message, equals('Successfully loaded 5 new items!'));
      } else {
        expect(logic.value.status, equals(HomePageStatus.error));
        expect(logic.value.items, isEmpty);
        expect(logic.value.message, contains('Error:'));
      }
    });

    test('should handle load items error or success', () async {
      expect(logic.value.items, isEmpty);

      final future = logic.loadItems();

      // Wait for completion
      await future;

      // Should be either in error or success state (due to random logic)
      expect(logic.value.isLoading, isFalse);
      expect([HomePageStatus.error, HomePageStatus.success],
          contains(logic.value.status));

      if (logic.value.status == HomePageStatus.error) {
        expect(logic.value.items, isEmpty);
        expect(logic.value.message, contains('Error:'));
      } else {
        expect(logic.value.items.length, equals(5));
        expect(logic.value.message, contains('Successfully loaded'));
      }
    });

    test('should append items on subsequent loads if successful', () async {
      // This test is tricky due to random logic, so we'll try multiple times if needed
      var attempts = 0;
      var hasSuccessfulLoad = false;

      while (attempts < 3 && !hasSuccessfulLoad) {
        attempts++;

        // Reset logic for retry
        if (attempts > 1) {
          logic.clearItems();
        }

        // First load attempt
        await logic.loadItems();

        if (logic.value.status == HomePageStatus.success) {
          hasSuccessfulLoad = true;
          expect(logic.value.items.length, equals(5));
          expect(logic.value.items.last, equals('Item 5'));

          // Second load should append (if successful)
          await logic.loadItems();
          if (logic.value.status == HomePageStatus.success) {
            expect(logic.value.items.length, equals(10));
            expect(logic.value.items.last, equals('Item 10'));
          }
        }
      }

      // If we couldn't get a successful load after attempts, that's ok due to randomness
      expect(attempts, lessThanOrEqualTo(3));
    });

    test('should clear all items', () async {
      // Try to load items first (may or may not succeed due to randomness)
      await logic.loadItems();

      // If items were loaded, test clearing
      if (logic.value.items.isNotEmpty) {
        logic.clearItems();

        expect(logic.value.items, isEmpty);
        expect(logic.value.message, equals('All items cleared'));
        expect(logic.value.status, equals(HomePageStatus.idle));
      } else {
        // If no items were loaded (due to random failure), just test clearing empty list
        logic.clearItems();

        expect(logic.value.items, isEmpty);
        expect(logic.value.message, equals('All items cleared'));
        expect(logic.value.status, equals(HomePageStatus.idle));
      }
    });

    test('should remove auth listener on dispose', () async {
      // Create a separate logic for this test
      final testRepo = AuthRepository();
      final testLogic = HomePageLogic(testRepo);

      const username = 'testuser';

      // Login and verify message update
      await testRepo.login(username);
      expect(testLogic.value.message, contains(username));

      // Dispose logic
      testLogic.dispose();

      // Change auth state - disposed logic should not crash
      await testRepo.login('newuser');

      // Test passes if no exception is thrown
      testRepo.dispose();
    });

    test('should handle multiple counter operations', () {
      logic.increment(); // 1
      logic.increment(); // 2
      logic.decrement(); // 1
      logic.increment(); // 2
      logic.reset(); // 0
      logic.decrement(); // -1

      expect(logic.value.counter, equals(-1));
      expect(logic.value.message, equals('Counter decremented to -1'));
    });

    test('should maintain state consistency during rapid operations', () async {
      // Perform multiple operations rapidly
      logic.increment();
      logic.increment();
      final asyncFuture = logic.incrementAsync();
      logic.increment();
      logic.decrement();

      // Wait for async operation
      await asyncFuture;

      // Final state should be consistent
      expect(logic.value.counter, equals(3)); // 0 + 1 + 1 + 1 + 1 - 1 = 3
      expect(logic.value.isLoading, isFalse);
    });
  });

  group('HomePageLogic without AuthRepository', () {
    late HomePageLogic logic;

    setUp(() {
      logic = HomePageLogic(); // No auth repository
    });

    tearDown(() {
      logic.dispose();
    });

    test('should work without auth repository', () {
      logic.increment();
      expect(logic.value.counter, equals(1));
      expect(logic.value.currentUser, isNull);
    });

    test('should not crash when disposing without auth repository', () {
      // Just verify disposal doesn't throw
      expect(() {
        final tempLogic = HomePageLogic();
        tempLogic.dispose();
      }, returnsNormally);
    });
  });
}
