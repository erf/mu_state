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
          builder: (context, List<MuEvent> events, child) {
            return switch (events) {
              [MuEventLoading _, MuEventLoading _] =>
                const Center(child: Text('Loading')),
              [MuEventError(error: _), MuEventError(error: _)] =>
                const Center(child: Text('Error')),
              [MuEventData(data: _), MuEventData(data: _)] =>
                const Center(child: Text('Data')),
              _ => const Center(child: Text('Invalid state')),
            };
          },
        ),
      ),
    );
  }
}

class TestStateOne extends MuState {
  TestStateOne(super.value);
}

class TestStateTwo extends MuState {
  TestStateTwo(super.value);
}

void main() {
  testWidgets('Create a TestWidget and expect state is Loading',
      (WidgetTester tester) async {
    final states = [
      TestStateOne(const MuEventLoading()),
      TestStateTwo(const MuEventLoading()),
    ];
    await tester.pumpWidget(TestWidget(states: states));

    expect(find.text('Loading'), findsOneWidget);
  });

  testWidgets('Create a TestWidget and expect state is Error',
      (WidgetTester tester) async {
    final states = [
      TestStateOne(const MuEventError('Error 1')),
      TestStateTwo(const MuEventError('Error 2')),
    ];
    await tester.pumpWidget(TestWidget(states: states));

    expect(find.text('Error'), findsOneWidget);
  });

  testWidgets('Create a TestWidget and expect state is Data',
      (WidgetTester tester) async {
    final states = [
      TestStateOne(const MuEventData('Data 1')),
      TestStateTwo(const MuEventData('Data 2')),
    ];
    await tester.pumpWidget(TestWidget(states: states));

    expect(find.text('Data'), findsOneWidget);
  });
}
