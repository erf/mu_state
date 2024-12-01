import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mu_state/mu_state.dart';

class TestWidget extends StatelessWidget {
  final List<MuState<MuEvent>> states;

  const TestWidget({super.key, required this.states});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: MuMultiBuilder(
          listenables: states,
          builder: (context, List events, child) {
            return switch (events) {
              [MuLoading _, MuLoading _] =>
                const Center(child: Text('Loading')),
              [MuError(error: _), MuError(error: _)] =>
                const Center(child: Text('Error')),
              [MuData(data: _), MuData(data: _)] =>
                const Center(child: Text('Data')),
              _ => const Center(child: Text('Invalid state')),
            };
          },
        ),
      ),
    );
  }
}

class TestStateOne extends MuState<MuEvent> {
  TestStateOne(super.value);
}

class TestStateTwo extends MuState<MuEvent> {
  TestStateTwo(super.value);
}

void main() {
  testWidgets('Create a TestWidget and expect state is Loading',
      (WidgetTester tester) async {
    final states = [
      TestStateOne(const MuLoading()),
      TestStateTwo(const MuLoading()),
    ];
    await tester.pumpWidget(TestWidget(states: states));

    expect(find.text('Loading'), findsOneWidget);
  });

  testWidgets('Create a TestWidget and expect state is Error',
      (WidgetTester tester) async {
    final states = [
      TestStateOne(const MuError('Error 1')),
      TestStateTwo(const MuError('Error 2')),
    ];
    await tester.pumpWidget(TestWidget(states: states));

    expect(find.text('Error'), findsOneWidget);
  });

  testWidgets('Create a TestWidget and expect state is Data',
      (WidgetTester tester) async {
    final states = [
      TestStateOne(const MuData('Data 1')),
      TestStateTwo(const MuData('Data 2')),
    ];
    await tester.pumpWidget(TestWidget(states: states));

    expect(find.text('Data'), findsOneWidget);
  });
}
