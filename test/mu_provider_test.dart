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

void main() {
  group('MuProvider Tests', () {
    testWidgets('should provide logic to descendants',
        (WidgetTester tester) async {
      final logic = TestLogic(10);
      late TestLogic retrievedLogic;

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
      expect(retrievedLogic.value.value, 10);
    });

    testWidgets('should throw when no provider found',
        (WidgetTester tester) async {
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

    testWidgets(
        'should return null when using maybeLogic and no provider found',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            final logic = context.maybeLogic<TestLogic, TestState>();
            expect(logic, isNull);
            return const SizedBox();
          },
        ),
      );
    });

    testWidgets('should NOT rebuild when logic value changes',
        (WidgetTester tester) async {
      final logic = TestLogic(0);
      int buildCount = 0;

      await tester.pumpWidget(
        MuProvider<TestLogic, TestState>(
          logic: logic,
          child: Builder(
            builder: (context) {
              buildCount++;
              final currentLogic = context.logic<TestLogic, TestState>();
              return Directionality(
                textDirection: TextDirection.ltr,
                child: Text('${currentLogic.value.value}'),
              );
            },
          ),
        ),
      );

      expect(buildCount, 1);
      expect(find.text('0'), findsOneWidget);

      // Change the logic value
      logic.increment();
      await tester.pump();

      // Should NOT rebuild because MuProvider doesn't listen to state changes
      expect(buildCount, 1);
      // Text should still show old value because no rebuild occurred
      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('should work with nested providers',
        (WidgetTester tester) async {
      final logic1 = TestLogic(1);
      final logic2 = TestLogic(2);

      await tester.pumpWidget(
        MuProvider<TestLogic, TestState>(
          logic: logic1,
          child: MuProvider<TestLogic, TestState>(
            logic: logic2,
            child: Builder(
              builder: (context) {
                final retrievedLogic = context.logic<TestLogic, TestState>();
                // Should get the closest provider (logic2)
                expect(retrievedLogic, same(logic2));
                expect(retrievedLogic.value.value, 2);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('should rebuild when logic instance changes',
        (WidgetTester tester) async {
      var logic = TestLogic(0);
      int buildCount = 0;

      Widget buildProvider(TestLogic logicInstance) {
        return MuProvider<TestLogic, TestState>(
          logic: logicInstance,
          child: Builder(
            builder: (context) {
              buildCount++;
              final currentLogic = context.logic<TestLogic, TestState>();
              return Directionality(
                textDirection: TextDirection.ltr,
                child: Text('${currentLogic.value.value}'),
              );
            },
          ),
        );
      }

      // Initial build
      await tester.pumpWidget(buildProvider(logic));
      expect(buildCount, 1);
      expect(find.text('0'), findsOneWidget);

      // Change logic instance and rebuild
      final newLogic = TestLogic(5);
      await tester.pumpWidget(buildProvider(newLogic));

      expect(buildCount, 2);
      expect(find.text('5'), findsOneWidget);
    });
  });

  group('MuContext Extension Tests', () {
    testWidgets('context.logic should work', (WidgetTester tester) async {
      final logic = TestLogic(42);

      await tester.pumpWidget(
        MuProvider<TestLogic, TestState>(
          logic: logic,
          child: Builder(
            builder: (context) {
              final retrievedLogic = context.logic<TestLogic, TestState>();
              expect(retrievedLogic.value.value, 42);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('context.maybeLogic should work', (WidgetTester tester) async {
      final logic = TestLogic(24);

      await tester.pumpWidget(
        MuProvider<TestLogic, TestState>(
          logic: logic,
          child: Builder(
            builder: (context) {
              final retrievedLogic = context.maybeLogic<TestLogic, TestState>();
              expect(retrievedLogic?.value.value, 24);
              return const SizedBox();
            },
          ),
        ),
      );
    });
  });
}
