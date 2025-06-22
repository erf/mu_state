import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mu_state/mu_state.dart';

class TestState with MuComparable {
  final int value;

  const TestState(this.value);

  TestState copyWith({int? value}) {
    return TestState(value ?? this.value);
  }

  @override
  List<Object?> get props => [value];
}

class TestLogic extends MuLogic<TestState> {
  TestLogic(int initialValue) : super(TestState(initialValue));

  void increment() {
    value = value.copyWith(value: value.value + 1);
  }
}

class AnotherTestState with MuComparable {
  final String message;

  const AnotherTestState(this.message);

  AnotherTestState copyWith({String? message}) {
    return AnotherTestState(message ?? this.message);
  }

  @override
  List<Object?> get props => [message];
}

class AnotherTestLogic extends MuLogic<AnotherTestState> {
  AnotherTestLogic(String initialMessage)
      : super(AnotherTestState(initialMessage));

  void updateMessage(String message) {
    value = value.copyWith(message: message);
  }
}

void main() {
  group('MuContext Extension Tests', () {
    testWidgets('context.logic should retrieve the correct logic instance',
        (tester) async {
      final logic = TestLogic(42);
      TestLogic? retrievedLogic;

      await tester.pumpWidget(
        MuProvider<TestLogic, TestState>(
          logic: logic,
          child: Builder(
            builder: (context) {
              retrievedLogic = context.logic<TestLogic, TestState>();
              return const SizedBox();
            },
          ),
        ),
      );

      expect(retrievedLogic, same(logic));
      expect(retrievedLogic!.value.value, 42);
    });

    testWidgets('context.maybeLogic should return logic when provider exists',
        (tester) async {
      final logic = TestLogic(24);
      TestLogic? retrievedLogic;

      await tester.pumpWidget(
        MuProvider<TestLogic, TestState>(
          logic: logic,
          child: Builder(
            builder: (context) {
              retrievedLogic = context.maybeLogic<TestLogic, TestState>();
              return const SizedBox();
            },
          ),
        ),
      );

      expect(retrievedLogic, same(logic));
      expect(retrievedLogic!.value.value, 24);
    });

    testWidgets('context.maybeLogic should return null when no provider exists',
        (tester) async {
      TestLogic? retrievedLogic;

      await tester.pumpWidget(
        Builder(
          builder: (context) {
            retrievedLogic = context.maybeLogic<TestLogic, TestState>();
            return const SizedBox();
          },
        ),
      );

      expect(retrievedLogic, isNull);
    });

    testWidgets('context.logic should throw when no provider found',
        (tester) async {
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            expect(
              () => context.logic<TestLogic, TestState>(),
              throwsA(isA<FlutterError>()),
            );
            return const SizedBox();
          },
        ),
      );
    });

    testWidgets('should work with multiple different logic types',
        (tester) async {
      final testLogic = TestLogic(100);
      final anotherLogic = AnotherTestLogic('hello');

      TestLogic? retrievedTestLogic;
      AnotherTestLogic? retrievedAnotherLogic;

      await tester.pumpWidget(
        MuProvider<TestLogic, TestState>(
          logic: testLogic,
          child: MuProvider<AnotherTestLogic, AnotherTestState>(
            logic: anotherLogic,
            child: Builder(
              builder: (context) {
                retrievedTestLogic = context.logic<TestLogic, TestState>();
                retrievedAnotherLogic =
                    context.logic<AnotherTestLogic, AnotherTestState>();
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(retrievedTestLogic, same(testLogic));
      expect(retrievedAnotherLogic, same(anotherLogic));
      expect(retrievedTestLogic!.value.value, 100);
      expect(retrievedAnotherLogic!.value.message, 'hello');
    });

    testWidgets('should get the closest provider when nested', (tester) async {
      final outerLogic = TestLogic(1);
      final innerLogic = TestLogic(2);
      TestLogic? retrievedLogic;

      await tester.pumpWidget(
        MuProvider<TestLogic, TestState>(
          logic: outerLogic,
          child: MuProvider<TestLogic, TestState>(
            logic: innerLogic,
            child: Builder(
              builder: (context) {
                retrievedLogic = context.logic<TestLogic, TestState>();
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      // Should get the closest (inner) provider
      expect(retrievedLogic, same(innerLogic));
      expect(retrievedLogic!.value.value, 2);
    });

    testWidgets('should work correctly when logic state changes',
        (tester) async {
      final logic = TestLogic(0);
      var retrievedValue = 0;

      await tester.pumpWidget(
        MuProvider<TestLogic, TestState>(
          logic: logic,
          child: Builder(
            builder: (context) {
              final currentLogic = context.logic<TestLogic, TestState>();
              retrievedValue = currentLogic.value.value;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(retrievedValue, 0);

      // Change the logic state
      logic.increment();

      // Rebuild to get the updated state
      await tester.pumpWidget(
        MuProvider<TestLogic, TestState>(
          logic: logic,
          child: Builder(
            builder: (context) {
              final currentLogic = context.logic<TestLogic, TestState>();
              retrievedValue = currentLogic.value.value;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(retrievedValue, 1);
    });
  });
}
