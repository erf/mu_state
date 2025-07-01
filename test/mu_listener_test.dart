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

class ErrorState extends TestState {
  const ErrorState({required super.error}) : super(data: 'error');
}

class LoadingState extends TestState {
  const LoadingState() : super(data: 'loading', isLoading: true);
}

class SuccessState extends TestState {
  const SuccessState({required super.data});
}

class TestLogic extends MuLogic<TestState> {
  TestLogic() : super(const TestState(data: 'initial'));

  void setLoading() {
    value = const LoadingState();
  }

  void setError(String error) {
    value = ErrorState(error: error);
  }

  void setSuccess(String data) {
    value = SuccessState(data: data);
  }

  void updateData(String data) {
    value = value.copyWith(data: data);
  }
}

void main() {
  group('MuListener', () {
    late TestLogic logic;
    late List<TestState> listenerStates;
    late List<BuildContext> listenerContexts;

    setUp(() {
      logic = TestLogic();
      listenerStates = [];
      listenerContexts = [];
    });

    testWidgets('calls listener when state changes', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MuListener<TestState>(
              logic: logic,
              listener: (context, state) {
                listenerStates.add(state);
                listenerContexts.add(context);
              },
              child: const Text('Child Widget'),
            ),
          ),
        ),
      );

      expect(listenerStates, isEmpty);

      logic.updateData('updated');
      await tester.pump();

      expect(listenerStates, hasLength(1));
      expect(listenerStates.first.data, equals('updated'));
      expect(listenerContexts, hasLength(1));
    });

    testWidgets('does not call listener on initial state when lazy is true',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MuListener<TestState>(
              logic: logic,
              lazy: true,
              listener: (context, state) {
                listenerStates.add(state);
              },
              child: const Text('Child Widget'),
            ),
          ),
        ),
      );

      await tester.pump();
      expect(listenerStates, isEmpty);
    });

    testWidgets('calls listener on initial state when lazy is false',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MuListener<TestState>(
              logic: logic,
              lazy: false,
              listener: (context, state) {
                listenerStates.add(state);
              },
              child: const Text('Child Widget'),
            ),
          ),
        ),
      );

      await tester.pump();
      expect(listenerStates, hasLength(1));
      expect(listenerStates.first.data, equals('initial'));
    });

    testWidgets('respects listenWhen condition', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MuListener<TestState>(
              logic: logic,
              listenWhen: (previous, current) =>
                  current.isLoading != previous.isLoading,
              listener: (context, state) {
                listenerStates.add(state);
              },
              child: const Text('Child Widget'),
            ),
          ),
        ),
      );

      // Should not trigger listener (isLoading doesn't change)
      logic.updateData('updated');
      await tester.pump();
      expect(listenerStates, isEmpty);

      // Should trigger listener (isLoading changes)
      logic.setLoading();
      await tester.pump();
      expect(listenerStates, hasLength(1));
      expect(listenerStates.first.isLoading, isTrue);

      // Should not trigger listener (isLoading doesn't change)
      logic.updateData('updated again');
      await tester.pump();
      expect(listenerStates, hasLength(1));

      // Should trigger listener (isLoading changes)
      logic.setSuccess('success');
      await tester.pump();
      expect(listenerStates, hasLength(2));
      expect(listenerStates.last.isLoading, isFalse);
    });

    testWidgets('calls listener for each state change', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MuListener<TestState>(
              logic: logic,
              listener: (context, state) {
                listenerStates.add(state);
              },
              child: const Text('Child Widget'),
            ),
          ),
        ),
      );

      logic.setLoading();
      await tester.pump();

      logic.setError('Something went wrong');
      await tester.pump();

      logic.setSuccess('Success!');
      await tester.pump();

      expect(listenerStates, hasLength(3));
      expect(listenerStates[0], isA<LoadingState>());
      expect(listenerStates[1], isA<ErrorState>());
      expect(listenerStates[2], isA<SuccessState>());
    });

    testWidgets('renders child widget correctly', (tester) async {
      const childKey = Key('child-widget');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MuListener<TestState>(
              logic: logic,
              listener: (context, state) {},
              child: const Text('Child Widget', key: childKey),
            ),
          ),
        ),
      );

      expect(find.byKey(childKey), findsOneWidget);
      expect(find.text('Child Widget'), findsOneWidget);
    });

    testWidgets('properly disposes listener', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MuListener<TestState>(
              logic: logic,
              listener: (context, state) {
                listenerStates.add(state);
              },
              child: const Text('Child Widget'),
            ),
          ),
        ),
      );

      // Verify listener is working
      logic.updateData('updated');
      await tester.pump();
      expect(listenerStates, hasLength(1));

      // Remove the widget
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Text('Different Widget'),
          ),
        ),
      );

      // Change state after disposal
      logic.updateData('should not trigger');
      await tester.pump();

      // Should still only have one state recorded
      expect(listenerStates, hasLength(1));
    });

    testWidgets('works with runtime type listenWhen', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MuListener<TestState>(
              logic: logic,
              listenWhen: (previous, current) =>
                  previous.runtimeType != current.runtimeType,
              listener: (context, state) {
                listenerStates.add(state);
              },
              child: const Text('Child Widget'),
            ),
          ),
        ),
      );

      // Should not trigger (same type)
      logic.updateData('updated');
      await tester.pump();
      expect(listenerStates, isEmpty);

      // Should trigger (different type)
      logic.setLoading();
      await tester.pump();
      expect(listenerStates, hasLength(1));
      expect(listenerStates.first, isA<LoadingState>());

      // Should trigger (different type)
      logic.setError('error');
      await tester.pump();
      expect(listenerStates, hasLength(2));
      expect(listenerStates.last, isA<ErrorState>());

      // Should trigger (different type)
      logic.setSuccess('success');
      await tester.pump();
      expect(listenerStates, hasLength(3));
      expect(listenerStates.last, isA<SuccessState>());

      // Should not trigger (same type)
      logic.setSuccess('another success');
      await tester.pump();
      expect(listenerStates, hasLength(3));
      expect(listenerStates.last.data, equals('success'));
    });

    testWidgets('can access context in listener', (tester) async {
      BuildContext? capturedContext;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MuListener<TestState>(
              logic: logic,
              listener: (context, state) {
                capturedContext = context;
              },
              child: const Text('Child Widget'),
            ),
          ),
        ),
      );

      logic.updateData('updated');
      await tester.pump();

      expect(capturedContext, isNotNull);
      expect(capturedContext!.widget, isA<MuListener<TestState>>());
    });
  });
}
