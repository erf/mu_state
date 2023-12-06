import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mu_state/mu_state.dart';

class TestWidget extends StatelessWidget {
  final List<MuState> states;

  const TestWidget({super.key, required this.states});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: MuMultiBuilder(
          states: states,
          builder: (context, List<MuEvent<dynamic>> events, child) {
            final event0 = events[0];
            final event1 = events[1];

            if (event0.loading || event1.loading) {
              return const Center(
                child: Text('Loading'),
              );
            }
            if (event0.hasError || event1.hasError) {
              return const Center(
                child: Text('Error'),
              );
            }
            if (event0.hasData || event1.hasData) {
              return const Center(
                child: Text('Data'),
              );
            }
            return const Center(
              child: Text('Invalid state'),
            );
          },
        ),
      ),
    );
  }
}

class TestStateOne extends MuState<String> {
  TestStateOne(super.value);
}

class TestStateTwo extends MuState<String> {
  TestStateTwo(super.value);
}

void main() {
  testWidgets('Create a TestWidget and expect state is Loading',
      (WidgetTester tester) async {
    final states = [
      TestStateOne(const MuEvent.loading()),
      TestStateTwo(const MuEvent.loading()),
    ];
    await tester.pumpWidget(TestWidget(states: states));

    expect(find.text('Loading'), findsOneWidget);
  });

  testWidgets('Create a TestWidget and expect state is Error',
      (WidgetTester tester) async {
    final states = [
      TestStateOne(const MuEvent.error('Error 1')),
      TestStateTwo(const MuEvent.error('Error 2')),
    ];
    await tester.pumpWidget(TestWidget(states: states));

    expect(find.text('Error'), findsOneWidget);
  });

  testWidgets('Create a TestWidget and expect state is Data',
      (WidgetTester tester) async {
    final states = [
      TestStateOne(const MuEvent.data('Data 1')),
      TestStateTwo(const MuEvent.data('Data 2')),
    ];
    await tester.pumpWidget(TestWidget(states: states));

    expect(find.text('Data'), findsOneWidget);
  });
}
