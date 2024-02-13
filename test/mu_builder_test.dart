import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mu_state/mu_state.dart';

class TestWidget extends StatelessWidget {
  final MuState state;

  const TestWidget(this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: MuBuilder(
          state: state,
          builder: (context, event, child) {
            return Center(
              child: switch (event) {
                MuEventLoading _ => const Text('Loading'),
                MuEventError _ => const Text('Error'),
                MuEventData _ => const Text('Data'),
              },
            );
          },
        ),
      ),
    );
  }
}

class TestState extends MuState {
  TestState(super.value);
}

void main() {
  testWidgets('TestWidget text is "Loading"', (WidgetTester tester) async {
    await tester.pumpWidget(TestWidget(TestState(const MuEventLoading())));
    expect(find.text('Loading'), findsOneWidget);
  });

  testWidgets('TestWidget text is "Error"', (WidgetTester tester) async {
    await tester.pumpWidget(TestWidget(TestState(const MuEventError(''))));
    expect(find.text('Error'), findsOneWidget);
  });

  testWidgets('TestWidget text is "Data"', (WidgetTester tester) async {
    await tester.pumpWidget(TestWidget(TestState(const MuEventData(''))));
    expect(find.text('Data'), findsOneWidget);
  });

  testWidgets('Change from one state to another', (WidgetTester tester) async {
    final state = TestState(const MuEventLoading());
    await tester.pumpWidget(TestWidget(state));
    expect(state.value, isA<MuEventLoading>());
    expect(find.text('Loading'), findsOneWidget);

    state.value = const MuEventData('');
    await tester.pump();
    expect(state.value is MuEventData, true);
    expect(find.text('Data'), findsOneWidget);

    state.value = const MuEventError('');
    await tester.pump();
    expect(state.value is MuEventError, true);
    expect(find.text('Error'), findsOneWidget);
  });
}
