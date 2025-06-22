import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mu_state/mu_state.dart';

// Test state classes
class TestState with MuComparable {
  final int value;
  final String message;

  const TestState({required this.value, required this.message});

  TestState copyWith({int? value, String? message}) {
    return TestState(
      value: value ?? this.value,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [value, message];
}

class TestLogic extends MuLogic<TestState> {
  TestLogic() : super(const TestState(value: 0, message: 'initial'));

  void updateValue(int newValue) {
    value = value.copyWith(value: newValue);
  }

  void updateMessage(String newMessage) {
    value = value.copyWith(message: newMessage);
  }
}

void main() {
  group('MuLogic Tests', () {
    test('should create MuLogic with initial state', () {
      final logic = TestLogic();
      expect(logic.value.value, 0);
      expect(logic.value.message, 'initial');
    });

    test('should update state using direct assignment', () {
      final logic = TestLogic();
      logic.value = const TestState(value: 42, message: 'updated');

      expect(logic.value.value, 42);
      expect(logic.value.message, 'updated');
    });

    test('should update state using logic methods', () {
      final logic = TestLogic();
      logic.updateValue(100);
      logic.updateMessage('hello');

      expect(logic.value.value, 100);
      expect(logic.value.message, 'hello');
    });

    test('should notify listeners on state change', () {
      final logic = TestLogic();
      bool notified = false;

      logic.addListener(() {
        notified = true;
      });

      logic.updateValue(999);
      expect(notified, true);
    });

    test('should dispose properly', () {
      final logic = TestLogic();
      var notificationCount = 0;

      logic.addListener(() {
        notificationCount++;
      });

      logic.updateValue(1);
      expect(notificationCount, 1);

      logic.dispose();

      // Should throw an error when used after disposal
      expect(() => logic.updateValue(2), throwsFlutterError);
      expect(notificationCount, 1); // Still 1, not 2
    });

    test('should work with different state types', () {
      final logic = MuLogic<String>('initial');
      
      expect(logic.value, 'initial');
      
      logic.value = 'updated';
      expect(logic.value, 'updated');
    });

    test('should work with nullable state types', () {
      final logic = MuLogic<String?>(null);
      
      expect(logic.value, isNull);
      
      logic.value = 'not null';
      expect(logic.value, 'not null');
      
      logic.value = null;
      expect(logic.value, isNull);
    });

    test('should be a ValueNotifier', () {
      final logic = TestLogic();
      
      // MuLogic should be a ValueNotifier
      expect(logic, isA<ValueNotifier<TestState>>());
    });
  });
}
