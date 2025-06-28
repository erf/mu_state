# Example App Test Suite

This directory contains comprehensive tests for the mu_state example application, focusing on core business logic and repository functionality.

## Test Structure

```
test/
├── README.md                        # This file
├── repository/
│   └── auth_repository_test.dart    # Repository tests
├── login/
│   └── login_logic_test.dart        # Login logic and state tests
└── home_page/
    └── home_page_logic_test.dart    # Home page logic and state tests
```

## Test Categories

### Repository Tests
- **repository/auth_repository_test.dart**: Tests for the authentication repository
  - Login/logout functionality
  - User state management
  - Async operations

### Logic Tests
- **login/login_logic_test.dart**: Tests for login business logic
  - State management
  - Authentication flow
  - Error handling
  - Resource cleanup

- **home_page/home_page_logic_test.dart**: Tests for home page business logic
  - Counter operations (increment, decrement, reset, async)
  - Items management (load, clear)
  - Status management
  - User state integration
  - Resource cleanup

## Running Tests

### Run All Tests
```bash
flutter test
```

### Run Individual Test Files
```bash
flutter test test/repository/auth_repository_test.dart
flutter test test/login/login_logic_test.dart
flutter test test/home_page/home_page_logic_test.dart
```

## Test Best Practices

### Logic Tests
- Test all public methods and state changes
- Test error conditions and edge cases
- Test async operations with proper timing
- Test resource cleanup (dispose methods)
- Test integration between components (e.g., auth repository and page logic)

### Repository Tests
- Test all CRUD operations
- Test async operations and error handling
- Test state notifications and listeners
- Test resource cleanup

## Test Utilities

The tests use several patterns and utilities:

1. **Setup/Teardown**: Proper initialization and cleanup of test objects
2. **State Verification**: Checking that state changes occur as expected
3. **Async Testing**: Testing async operations with proper timing controls
4. **Error Testing**: Verifying error conditions and recovery
5. **Integration Testing**: Testing how components work together

## Coverage

The test suite covers:
- ✅ Repository functionality
- ✅ Business logic and state management
- ✅ Error handling and edge cases
- ✅ Async operations
- ✅ Resource cleanup
- ✅ Component integration

This focused approach ensures that the core business logic is thoroughly tested and reliable.

## Key Testing Patterns

### State Testing
```dart
test('should copy with new values', () {
  const original = LoginState(user: 'original');
  final copied = original.copyWith(user: 'updated');
  expect(copied.user, equals('updated'));
  expect(original.user, equals('original')); // Original unchanged
});
```

### Logic Testing
```dart
test('should login successfully', () async {
  await loginLogic.login('testuser');
  expect(loginLogic.value.signedIn, isTrue);
  expect(loginLogic.value.user, equals('testuser'));
});
```

### Repository Testing
```dart
test('should notify listeners on state change', () async {
  bool notified = false;
  authRepository.currentUser.addListener(() => notified = true);
  await authRepository.login('testuser');
  expect(notified, isTrue);
});
```
