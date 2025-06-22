import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mu_state/mu_state.dart';

class TestState with MuComparable {
  final String data;
  final bool isLoading;
  final String? error;

  const TestState({
    required this.data,
    this.isLoading = false,
    this.error,
  });

  TestState copyWith({
    String? data,
    bool? isLoading,
    String? error,
  }) {
    return TestState(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [data, isLoading, error];
}

class TestLogic extends MuLogic<TestState> {
  TestLogic() : super(const TestState(data: 'initial'));

  void setLoading() {
    value = value.copyWith(isLoading: true);
  }

  void setError(String error) {
    value = value.copyWith(error: error, isLoading: false);
  }

  void setSuccess(String data) {
    value = value.copyWith(data: data, isLoading: false, error: null);
  }
}

class TestWidget extends StatelessWidget {
  final TestLogic logic;

  const TestWidget(this.logic, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MuBuilder<TestState>(
        valueListenable: logic,
        builder: (context, state, child) {
          return switch (state) {
            TestState(isLoading: true) => const Text('Loading'),
            TestState(error: String error) => Text('Error: $error'),
            TestState(data: String? data) => Text('Data: $data'),
          };
        },
      ),
    );
  }
}

void main() {
  group('MuBuilder Tests', () {
    testWidgets('should display loading state', (WidgetTester tester) async {
      final logic = TestLogic();
      logic.setLoading();

      await tester.pumpWidget(TestWidget(logic));
      expect(find.text('Loading'), findsOneWidget);
    });

    testWidgets('should display error state', (WidgetTester tester) async {
      final logic = TestLogic();
      logic.setError('test error');

      await tester.pumpWidget(TestWidget(logic));
      expect(find.text('Error: test error'), findsOneWidget);
    });

    testWidgets('should display data state', (WidgetTester tester) async {
      final logic = TestLogic();
      logic.setSuccess('test data');

      await tester.pumpWidget(TestWidget(logic));
      expect(find.text('Data: test data'), findsOneWidget);
    });

    testWidgets('should rebuild when state changes',
        (WidgetTester tester) async {
      final logic = TestLogic();

      await tester.pumpWidget(TestWidget(logic));
      expect(find.text('Data: initial'), findsOneWidget);

      logic.setLoading();
      await tester.pump();
      expect(find.text('Loading'), findsOneWidget);

      logic.setSuccess('updated data');
      await tester.pump();
      expect(find.text('Data: updated data'), findsOneWidget);
    });
  });
}
