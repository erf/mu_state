import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mu_state/mu_state.dart';

class TestStateOne with MuComparable {
  final String value;

  const TestStateOne(this.value);

  TestStateOne copyWith({String? value}) {
    return TestStateOne(value ?? this.value);
  }

  @override
  List<Object?> get props => [value];
}

class TestStateTwo with MuComparable {
  final int value;

  const TestStateTwo(this.value);

  TestStateTwo copyWith({int? value}) {
    return TestStateTwo(value ?? this.value);
  }

  @override
  List<Object?> get props => [value];
}

class TestLogicOne extends MuLogic<TestStateOne> {
  TestLogicOne() : super(const TestStateOne('initial1'));

  void updateValue(String newValue) {
    value = value.copyWith(value: newValue);
  }
}

class TestLogicTwo extends MuLogic<TestStateTwo> {
  TestLogicTwo() : super(const TestStateTwo(0));

  void updateValue(int newValue) {
    value = value.copyWith(value: newValue);
  }
}

class TestWidget extends StatelessWidget {
  final List<MuLogic> logics;

  const TestWidget(this.logics, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MuMultiBuilder(
        listenables: logics,
        builder: (context, values, child) {
          return Column(
            children: [
              Text('State1: ${(values[0] as TestStateOne).value}'),
              Text('State2: ${(values[1] as TestStateTwo).value}'),
            ],
          );
        },
      ),
    );
  }
}

void main() {
  group('MuMultiBuilder Tests', () {
    testWidgets('should display initial states', (WidgetTester tester) async {
      final logic1 = TestLogicOne();
      final logic2 = TestLogicTwo();

      await tester.pumpWidget(TestWidget([logic1, logic2]));

      expect(find.text('State1: initial1'), findsOneWidget);
      expect(find.text('State2: 0'), findsOneWidget);
    });

    testWidgets('should rebuild when first state changes',
        (WidgetTester tester) async {
      final logic1 = TestLogicOne();
      final logic2 = TestLogicTwo();

      await tester.pumpWidget(TestWidget([logic1, logic2]));

      logic1.updateValue('updated1');
      await tester.pump();

      expect(find.text('State1: updated1'), findsOneWidget);
      expect(find.text('State2: 0'), findsOneWidget);
    });

    testWidgets('should rebuild when second state changes',
        (WidgetTester tester) async {
      final logic1 = TestLogicOne();
      final logic2 = TestLogicTwo();

      await tester.pumpWidget(TestWidget([logic1, logic2]));

      logic2.updateValue(42);
      await tester.pump();

      expect(find.text('State1: initial1'), findsOneWidget);
      expect(find.text('State2: 42'), findsOneWidget);
    });

    testWidgets('should rebuild when both states change',
        (WidgetTester tester) async {
      final logic1 = TestLogicOne();
      final logic2 = TestLogicTwo();

      await tester.pumpWidget(TestWidget([logic1, logic2]));

      logic1.updateValue('both1');
      logic2.updateValue(99);
      await tester.pump();

      expect(find.text('State1: both1'), findsOneWidget);
      expect(find.text('State2: 99'), findsOneWidget);
    });
  });
}
