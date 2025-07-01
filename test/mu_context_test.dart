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

// Test class for non-logic types
class TestRepository {
  final String name;
  final List<String> data;

  TestRepository(this.name, this.data);

  void addData(String item) {
    data.add(item);
  }
}

void main() {
  group('MuContext Extension Tests', () {
    group('logic methods', () {
      testWidgets('context.logic should retrieve the correct logic instance',
          (tester) async {
        final logic = TestLogic(42);
        TestLogic? retrievedLogic;

        await tester.pumpWidget(
          MuProvider<TestLogic>(
            value: logic,
            child: Builder(
              builder: (context) {
                retrievedLogic = context.logic<TestLogic>();
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
          MuProvider<TestLogic>(
            value: logic,
            child: Builder(
              builder: (context) {
                retrievedLogic = context.maybeLogic<TestLogic>();
                return const SizedBox();
              },
            ),
          ),
        );

        expect(retrievedLogic, same(logic));
        expect(retrievedLogic!.value.value, 24);
      });

      testWidgets(
          'context.maybeLogic should return null when no provider exists',
          (tester) async {
        TestLogic? retrievedLogic;

        await tester.pumpWidget(
          Builder(
            builder: (context) {
              retrievedLogic = context.maybeLogic<TestLogic>();
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
                () => context.logic<TestLogic>(),
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
          MuProvider<TestLogic>(
            value: testLogic,
            child: MuProvider<AnotherTestLogic>(
              value: anotherLogic,
              child: Builder(
                builder: (context) {
                  retrievedTestLogic = context.logic<TestLogic>();
                  retrievedAnotherLogic = context.logic<AnotherTestLogic>();
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

      testWidgets('should get the closest provider when nested',
          (tester) async {
        final outerLogic = TestLogic(1);
        final innerLogic = TestLogic(2);
        TestLogic? retrievedLogic;

        await tester.pumpWidget(
          MuProvider<TestLogic>(
            value: outerLogic,
            child: MuProvider<TestLogic>(
              value: innerLogic,
              child: Builder(
                builder: (context) {
                  retrievedLogic = context.logic<TestLogic>();
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
          MuProvider<TestLogic>(
            value: logic,
            child: Builder(
              builder: (context) {
                final currentLogic = context.logic<TestLogic>();
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
          MuProvider<TestLogic>(
            value: logic,
            child: Builder(
              builder: (context) {
                final currentLogic = context.logic<TestLogic>();
                retrievedValue = currentLogic.value.value;
                return const SizedBox();
              },
            ),
          ),
        );

        expect(retrievedValue, 1);
      });
    });

    group('read methods', () {
      testWidgets('context.read should retrieve the correct value',
          (tester) async {
        final repository = TestRepository('test', ['item1', 'item2']);
        TestRepository? retrievedRepository;

        await tester.pumpWidget(
          MuProvider<TestRepository>(
            value: repository,
            child: Builder(
              builder: (context) {
                retrievedRepository = context.read<TestRepository>();
                return const SizedBox();
              },
            ),
          ),
        );

        expect(retrievedRepository, same(repository));
        expect(retrievedRepository!.name, 'test');
        expect(retrievedRepository!.data, ['item1', 'item2']);
      });

      testWidgets('context.maybeRead should return value when provider exists',
          (tester) async {
        final repository = TestRepository('test', ['data']);
        TestRepository? retrievedRepository;

        await tester.pumpWidget(
          MuProvider<TestRepository>(
            value: repository,
            child: Builder(
              builder: (context) {
                retrievedRepository = context.maybeRead<TestRepository>();
                return const SizedBox();
              },
            ),
          ),
        );

        expect(retrievedRepository, same(repository));
        expect(retrievedRepository!.name, 'test');
      });

      testWidgets(
          'context.maybeRead should return null when no provider exists',
          (tester) async {
        TestRepository? retrievedRepository;

        await tester.pumpWidget(
          Builder(
            builder: (context) {
              retrievedRepository = context.maybeRead<TestRepository>();
              return const SizedBox();
            },
          ),
        );

        expect(retrievedRepository, isNull);
      });

      testWidgets('context.read should throw when no provider found',
          (tester) async {
        await tester.pumpWidget(
          Builder(
            builder: (context) {
              expect(
                () => context.read<TestRepository>(),
                throwsA(isA<FlutterError>()),
              );
              return const SizedBox();
            },
          ),
        );
      });

      testWidgets('should work with multiple different types', (tester) async {
        final repository = TestRepository('repo', ['data']);
        final logic = TestLogic(42);

        TestRepository? retrievedRepository;
        TestLogic? retrievedLogic;

        await tester.pumpWidget(
          MuProvider<TestRepository>(
            value: repository,
            child: MuProvider<TestLogic>(
              value: logic,
              child: Builder(
                builder: (context) {
                  retrievedRepository = context.read<TestRepository>();
                  retrievedLogic = context.logic<TestLogic>();
                  return const SizedBox();
                },
              ),
            ),
          ),
        );

        expect(retrievedRepository, same(repository));
        expect(retrievedLogic, same(logic));
        expect(retrievedRepository!.name, 'repo');
        expect(retrievedLogic!.value.value, 42);
      });

      testWidgets('should get the closest provider when nested',
          (tester) async {
        final outerRepository = TestRepository('outer', ['data1']);
        final innerRepository = TestRepository('inner', ['data2']);
        TestRepository? retrievedRepository;

        await tester.pumpWidget(
          MuProvider<TestRepository>(
            value: outerRepository,
            child: MuProvider<TestRepository>(
              value: innerRepository,
              child: Builder(
                builder: (context) {
                  retrievedRepository = context.read<TestRepository>();
                  return const SizedBox();
                },
              ),
            ),
          ),
        );

        // Should get the closest (inner) provider
        expect(retrievedRepository, same(innerRepository));
        expect(retrievedRepository!.name, 'inner');
      });
    });

    group('mixed logic and non-logic types', () {
      testWidgets('should work with both logic and repository together',
          (tester) async {
        final logic = TestLogic(100);
        final repository = TestRepository('mixed', ['test']);

        TestLogic? retrievedLogic;
        TestRepository? retrievedRepository;

        await tester.pumpWidget(
          MuProvider<TestLogic>(
            value: logic,
            child: MuProvider<TestRepository>(
              value: repository,
              child: Builder(
                builder: (context) {
                  retrievedLogic = context.logic<TestLogic>();
                  retrievedRepository = context.read<TestRepository>();
                  return const SizedBox();
                },
              ),
            ),
          ),
        );

        expect(retrievedLogic, same(logic));
        expect(retrievedRepository, same(repository));
        expect(retrievedLogic!.value.value, 100);
        expect(retrievedRepository!.name, 'mixed');
      });

      testWidgets('maybeRead and maybeLogic should work independently',
          (tester) async {
        final logic = TestLogic(50);
        TestLogic? retrievedLogic;
        TestRepository? retrievedRepository;

        await tester.pumpWidget(
          MuProvider<TestLogic>(
            value: logic,
            child: Builder(
              builder: (context) {
                retrievedLogic = context.maybeLogic<TestLogic>();
                retrievedRepository = context.maybeRead<TestRepository>();
                return const SizedBox();
              },
            ),
          ),
        );

        expect(retrievedLogic, same(logic));
        expect(retrievedRepository, isNull);
      });
    });
  });
}
