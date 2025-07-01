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
    bool clearError = false,
  }) {
    return TestState(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [data, isLoading, error];
}

class TestLogic extends MuLogic<TestState> {
  TestLogic(String initialData) : super(TestState(data: initialData));

  void updateData(String data) {
    value = value.copyWith(data: data, clearError: true);
  }

  void setError(String error) {
    value = value.copyWith(error: error);
  }
}

void main() {
  group('MuMultiListener', () {
    late TestLogic logicA;
    late TestLogic logicB;
    late List<String> listenerCallsA;
    late List<String> listenerCallsB;

    setUp(() {
      logicA = TestLogic('initialA');
      logicB = TestLogic('initialB');
      listenerCallsA = [];
      listenerCallsB = [];
    });

    testWidgets('listens to multiple logic instances', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MuMultiListener(
              listeners: [
                (child) => MuListener<TestState>(
                      logic: logicA,
                      listener: (context, state) {
                        listenerCallsA.add(state.data);
                      },
                      child: child,
                    ),
                (child) => MuListener<TestState>(
                      logic: logicB,
                      listener: (context, state) {
                        listenerCallsB.add(state.data);
                      },
                      child: child,
                    ),
              ],
              child: const Text('Test Widget'),
            ),
          ),
        ),
      );

      expect(listenerCallsA, isEmpty);
      expect(listenerCallsB, isEmpty);

      logicA.updateData('updatedA');
      await tester.pump();

      expect(listenerCallsA, equals(['updatedA']));
      expect(listenerCallsB, isEmpty);

      logicB.updateData('updatedB');
      await tester.pump();

      expect(listenerCallsA, equals(['updatedA']));
      expect(listenerCallsB, equals(['updatedB']));
    });

    testWidgets('supports listenWhen conditions', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MuMultiListener(
              listeners: [
                (child) => MuListener<TestState>(
                      logic: logicA,
                      listenWhen: (prev, curr) => prev.data != curr.data,
                      listener: (context, state) {
                        listenerCallsA.add(state.data);
                      },
                      child: child,
                    ),
                (child) => MuListener<TestState>(
                      logic: logicB,
                      listenWhen: (prev, curr) => curr.error != null,
                      listener: (context, state) {
                        listenerCallsB.add(state.error ?? 'no-error');
                      },
                      child: child,
                    ),
              ],
              child: const Text('Test Widget'),
            ),
          ),
        ),
      );

      // Update data - should trigger first listener
      logicA.updateData('newDataA');
      await tester.pump();

      expect(listenerCallsA, equals(['newDataA']));
      expect(listenerCallsB, isEmpty);

      // Set error - should trigger second listener
      logicB.setError('error occurred');
      await tester.pump();

      expect(listenerCallsA, equals(['newDataA']));
      expect(listenerCallsB, equals(['error occurred']));

      // Update data again - should not trigger second listener (no error condition)
      logicB.updateData('newDataB');
      await tester.pump();

      expect(listenerCallsA, equals(['newDataA']));
      expect(listenerCallsB, equals(['error occurred'])); // Still only one call
    });

    testWidgets('supports lazy parameter', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MuMultiListener(
              listeners: [
                (child) => MuListener<TestState>(
                      logic: logicA,
                      lazy: false,
                      listener: (context, state) {
                        listenerCallsA.add(state.data);
                      },
                      child: child,
                    ),
                (child) => MuListener<TestState>(
                      logic: logicB,
                      lazy: true, // default
                      listener: (context, state) {
                        listenerCallsB.add(state.data);
                      },
                      child: child,
                    ),
              ],
              child: const Text('Test Widget'),
            ),
          ),
        ),
      );

      await tester.pump();

      // First listener should be called immediately (lazy: false)
      expect(listenerCallsA, equals(['initialA']));
      // Second listener should not be called (lazy: true)
      expect(listenerCallsB, isEmpty);
    });

    testWidgets('renders child widget correctly', (tester) async {
      const childKey = Key('child-widget');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MuMultiListener(
              listeners: [
                (child) => MuListener<TestState>(
                      logic: logicA,
                      listener: (context, state) {},
                      child: child,
                    ),
              ],
              child: const Text('Child Widget', key: childKey),
            ),
          ),
        ),
      );

      expect(find.byKey(childKey), findsOneWidget);
      expect(find.text('Child Widget'), findsOneWidget);
    });

    testWidgets('properly disposes all listeners', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MuMultiListener(
              listeners: [
                (child) => MuListener<TestState>(
                      logic: logicA,
                      listener: (context, state) {
                        listenerCallsA.add(state.data);
                      },
                      child: child,
                    ),
                (child) => MuListener<TestState>(
                      logic: logicB,
                      listener: (context, state) {
                        listenerCallsB.add(state.data);
                      },
                      child: child,
                    ),
              ],
              child: const Text('Test Widget'),
            ),
          ),
        ),
      );

      // Verify listeners are working
      logicA.updateData('test1');
      logicB.updateData('test2');
      await tester.pump();

      expect(listenerCallsA, equals(['test1']));
      expect(listenerCallsB, equals(['test2']));

      // Remove the widget
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Text('Different Widget'),
          ),
        ),
      );

      // Change state after disposal - should not trigger listeners
      logicA.updateData('after disposal');
      logicB.updateData('after disposal');
      await tester.pump();

      // Should still only have the previous calls
      expect(listenerCallsA, equals(['test1']));
      expect(listenerCallsB, equals(['test2']));
    });

    testWidgets('works with empty listeners list', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MuMultiListener(
              listeners: const [],
              child: const Text('Child Widget'),
            ),
          ),
        ),
      );

      expect(find.text('Child Widget'), findsOneWidget);
    });
  });
}
