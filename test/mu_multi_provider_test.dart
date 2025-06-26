import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mu_state/mu_state.dart';

// Test state
class TestState with MuComparable {
  final String value;
  final bool isLoading;

  const TestState({this.value = 'initial', this.isLoading = false});

  TestState copyWith({String? value, bool? isLoading}) {
    return TestState(
      value: value ?? this.value,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [value, isLoading];
}

// Test logic
class TestLogic extends MuLogic<TestState> {
  TestLogic() : super(const TestState());

  void updateValue(String newValue) {
    value = value.copyWith(value: newValue);
  }
}

// Second test state
class SecondTestState with MuComparable {
  final int count;

  const SecondTestState({this.count = 0});

  SecondTestState copyWith({int? count}) {
    return SecondTestState(count: count ?? this.count);
  }

  @override
  List<Object?> get props => [count];
}

// Second test logic
class SecondTestLogic extends MuLogic<SecondTestState> {
  SecondTestLogic() : super(const SecondTestState());

  void increment() {
    value = value.copyWith(count: value.count + 1);
  }
}

void main() {
  group('MuMultiProvider', () {
    testWidgets('provides multiple logic instances correctly', (tester) async {
      final firstLogic = TestLogic();
      final secondLogic = SecondTestLogic();

      String? capturedFirstValue;
      int? capturedSecondValue;

      await tester.pumpWidget(
        MaterialApp(
          home: MuMultiProvider([
            (child) => MuProvider<TestLogic, TestState>(
                  logic: firstLogic,
                  child: child,
                ),
            (child) => MuProvider<SecondTestLogic, SecondTestState>(
                  logic: secondLogic,
                  child: child,
                ),
          ], child: Builder(
            builder: (context) {
              final first = context.logic<TestLogic, TestState>();
              final second = context.logic<SecondTestLogic, SecondTestState>();

              capturedFirstValue = first.value.value;
              capturedSecondValue = second.value.count;

              return const SizedBox();
            },
          )),
        ),
      );

      expect(capturedFirstValue, equals('initial'));
      expect(capturedSecondValue, equals(0));

      // Test that we can update both
      firstLogic.updateValue('updated');
      secondLogic.increment();

      await tester.pump();

      expect(firstLogic.value.value, equals('updated'));
      expect(secondLogic.value.count, equals(1));
    });

    testWidgets('nests providers in correct order', (tester) async {
      final firstLogic = TestLogic();
      final secondLogic = SecondTestLogic();

      await tester.pumpWidget(
        MaterialApp(
          home: MuMultiProvider([
            (child) => MuProvider<TestLogic, TestState>(
                  logic: firstLogic,
                  child: child,
                ),
            (child) => MuProvider<SecondTestLogic, SecondTestState>(
                  logic: secondLogic,
                  child: child,
                ),
          ], child: Builder(
            builder: (context) {
              // Both should be accessible
              final first = context.logic<TestLogic, TestState>();
              final second = context.logic<SecondTestLogic, SecondTestState>();

              expect(first, equals(firstLogic));
              expect(second, equals(secondLogic));

              return const SizedBox();
            },
          )),
        ),
      );
    });
  });
}
