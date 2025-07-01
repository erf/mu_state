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
    value = value.copyWith(data: data, isLoading: false, clearError: true);
  }

  void setError(String error) {
    value = value.copyWith(error: error);
  }

  void setLoading(bool loading) {
    value = value.copyWith(isLoading: loading);
  }
}

void main() {
  group('MuConsumer', () {
    late TestLogic logic;
    late List<String> listenerCalls;
    late List<String> builderCalls;

    setUp(() {
      logic = TestLogic('initial');
      listenerCalls = [];
      builderCalls = [];
    });

    testWidgets('calls both listener and builder on state change',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MuConsumer<TestState>(
              logic: logic,
              listener: (context, state) {
                listenerCalls.add(state.data);
              },
              builder: (context, state, child) {
                builderCalls.add(state.data);
                return Text('Data: ${state.data}');
              },
            ),
          ),
        ),
      );

      // Initial build should call builder but not listener (lazy: true by default)
      expect(builderCalls, equals(['initial']));
      expect(listenerCalls, isEmpty);

      // Update state
      logic.updateData('updated');
      await tester.pump();

      // Both should be called
      expect(builderCalls, equals(['initial', 'updated']));
      expect(listenerCalls, equals(['updated']));
      expect(find.text('Data: updated'), findsOneWidget);
    });

    testWidgets('calls listener immediately when lazy is false',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MuConsumer<TestState>(
              logic: logic,
              lazy: false,
              listener: (context, state) {
                listenerCalls.add(state.data);
              },
              builder: (context, state, child) {
                builderCalls.add(state.data);
                return Text('Data: ${state.data}');
              },
            ),
          ),
        ),
      );

      await tester.pump();

      // Both should be called with initial state
      expect(builderCalls, equals(['initial']));
      expect(listenerCalls, equals(['initial']));
    });

    testWidgets('respects listenWhen condition', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MuConsumer<TestState>(
              logic: logic,
              listenWhen: (prev, curr) => curr.error != null,
              listener: (context, state) {
                listenerCalls.add(state.error ?? 'no-error');
              },
              builder: (context, state, child) {
                builderCalls.add(state.data);
                return Text('Data: ${state.data}');
              },
            ),
          ),
        ),
      );

      // Update data - should trigger builder but not listener
      logic.updateData('newData');
      await tester.pump();

      expect(builderCalls, equals(['initial', 'newData']));
      expect(listenerCalls, isEmpty);

      // Set error - should trigger both listener and builder
      logic.setError('error occurred');
      await tester.pump();

      expect(builderCalls, equals(['initial', 'newData', 'newData']));
      expect(listenerCalls, equals(['error occurred']));
    });

    testWidgets('respects buildWhen condition', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MuConsumer<TestState>(
              logic: logic,
              buildWhen: (prev, curr) => prev.data != curr.data,
              listener: (context, state) {
                listenerCalls.add('${state.data}-${state.isLoading}');
              },
              builder: (context, state, child) {
                builderCalls.add(state.data);
                return Text('Data: ${state.data}');
              },
            ),
          ),
        ),
      );

      // Set loading - should trigger listener but not builder
      logic.setLoading(true);
      await tester.pump();

      expect(builderCalls, equals(['initial']));
      expect(listenerCalls, equals(['initial-true']));

      // Update data - should trigger both listener and builder
      logic.updateData('newData');
      await tester.pump();

      expect(builderCalls, equals(['initial', 'newData']));
      expect(listenerCalls, equals(['initial-true', 'newData-false']));
    });

    testWidgets('respects both listenWhen and buildWhen conditions',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MuConsumer<TestState>(
              logic: logic,
              listenWhen: (prev, curr) => curr.error != null,
              buildWhen: (prev, curr) => prev.data != curr.data,
              listener: (context, state) {
                listenerCalls.add(state.error ?? 'no-error');
              },
              builder: (context, state, child) {
                builderCalls.add(state.data);
                return Text('Data: ${state.data}');
              },
            ),
          ),
        ),
      );

      // Set loading - should trigger neither
      logic.setLoading(true);
      await tester.pump();

      expect(builderCalls, equals(['initial']));
      expect(listenerCalls, isEmpty);

      // Update data - should trigger builder but not listener
      logic.updateData('newData');
      await tester.pump();

      expect(builderCalls, equals(['initial', 'newData']));
      expect(listenerCalls, isEmpty);

      // Set error - should trigger listener but not builder (data didn't change)
      logic.setError('error occurred');
      await tester.pump();

      expect(builderCalls, equals(['initial', 'newData']));
      expect(listenerCalls, equals(['error occurred']));
    });

    testWidgets('passes child to builder', (tester) async {
      const childKey = Key('child-widget');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MuConsumer<TestState>(
              logic: logic,
              listener: (context, state) {},
              builder: (context, state, child) {
                return Column(
                  children: [
                    Text('Data: ${state.data}'),
                    if (child != null) child,
                  ],
                );
              },
              child: const Text('Child Widget', key: childKey),
            ),
          ),
        ),
      );

      expect(find.byKey(childKey), findsOneWidget);
      expect(find.text('Child Widget'), findsOneWidget);
      expect(find.text('Data: initial'), findsOneWidget);
    });

    testWidgets('properly disposes listener', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MuConsumer<TestState>(
              logic: logic,
              listener: (context, state) {
                listenerCalls.add(state.data);
              },
              builder: (context, state, child) {
                builderCalls.add(state.data);
                return Text('Data: ${state.data}');
              },
            ),
          ),
        ),
      );

      // Verify consumer is working
      logic.updateData('test');
      await tester.pump();

      expect(listenerCalls, equals(['test']));
      expect(builderCalls, equals(['initial', 'test']));

      // Remove the widget
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Text('Different Widget'),
          ),
        ),
      );

      // Change state after disposal - should not trigger listener or builder
      logic.updateData('after disposal');
      await tester.pump();

      // Should still only have the previous calls
      expect(listenerCalls, equals(['test']));
      expect(builderCalls, equals(['initial', 'test']));
    });

    testWidgets('works without optional parameters', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MuConsumer<TestState>(
              logic: logic,
              listener: (context, state) {
                listenerCalls.add(state.data);
              },
              builder: (context, state, child) {
                builderCalls.add(state.data);
                return Text('Data: ${state.data}');
              },
            ),
          ),
        ),
      );

      logic.updateData('test');
      await tester.pump();

      expect(listenerCalls, equals(['test']));
      expect(builderCalls, equals(['initial', 'test']));
      expect(find.text('Data: test'), findsOneWidget);
    });
  });
}
