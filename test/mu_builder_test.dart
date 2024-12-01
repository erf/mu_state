import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mu_state/mu_state.dart';

class TestWidget extends StatelessWidget {
  final MuState<MuEvent<String>> state;

  const TestWidget(this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: MuBuilder(
          valueListenable: state,
          builder: (context, event, child) {
            return Center(
              child: switch (event) {
                MuLoading() => const Text('Loading'),
                MuError(error: Object error) => Text('Error: $error'),
                MuData(data: String data) => Text('Data: $data'),
              },
            );
          },
        ),
      ),
    );
  }
}

class TestState extends MuState<MuEvent<String>> {
  TestState(super.value);
}

void main() {
  testWidgets('TestWidget text is "Loading"', (WidgetTester tester) async {
    await tester.pumpWidget(TestWidget(TestState(const MuLoading())));
    expect(find.text('Loading'), findsOneWidget);
  });

  testWidgets('TestWidget text is "Error"', (WidgetTester tester) async {
    await tester.pumpWidget(TestWidget(TestState(const MuError('error'))));
    expect(find.text('Error: error'), findsOneWidget);
  });

  testWidgets('TestWidget text is "Data"', (WidgetTester tester) async {
    await tester.pumpWidget(TestWidget(TestState(const MuData('data'))));
    expect(find.text('Data: data'), findsOneWidget);
  });

  testWidgets('Change from one state to another', (WidgetTester tester) async {
    final state = TestState(const MuLoading());
    await tester.pumpWidget(TestWidget(state));
    expect(state.value, isA<MuLoading>());
    expect(find.text('Loading'), findsOneWidget);

    state.value = const MuData('data');
    await tester.pump();
    expect(state.value is MuData, true);
    expect(find.text('Data: data'), findsOneWidget);

    state.value = const MuError('error');
    await tester.pump();
    expect(state.value is MuError, true);
    expect(find.text('Error: error'), findsOneWidget);
  });
}
