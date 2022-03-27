import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mu_state/mu_state.dart';

class TestWidget extends StatelessWidget {
  final MuState state;

  const TestWidget({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: MuBuilder(
          state: state,
          builder: (context, event, child) {
            if (event.loading) {
              return const Center(
                child: Text('Loading'),
              );
            }
            if (event.hasError) {
              return const Center(
                child: Text('Error'),
              );
            }
            if (event.hasData) {
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

class TestState extends MuState<String> {
  TestState(MuEvent<String> value) : super(value);
}

void main() {
  testWidgets('Create a TestWidget and expect state is Loading',
      (WidgetTester tester) async {
    await tester
        .pumpWidget(TestWidget(state: TestState(const MuEvent.loading())));

    expect(find.text('Loading'), findsOneWidget);
  });

  testWidgets('Create a TestWidget and expect state is Error',
      (WidgetTester tester) async {
    await tester.pumpWidget(
        TestWidget(state: TestState(const MuEvent.error('Some error'))));

    expect(find.text('Error'), findsOneWidget);
  });

  testWidgets('Create a TestWidget and expect state is Data',
      (WidgetTester tester) async {
    await tester.pumpWidget(
        TestWidget(state: TestState(const MuEvent.data('Some data'))));

    expect(find.text('Data'), findsOneWidget);
  });

  testWidgets('Change from one state to another', (WidgetTester tester) async {
    final state = TestState(const MuEvent.loading());
    await tester.pumpWidget(TestWidget(state: state));
    expect(state.value.loading, true);
    expect(find.text('Loading'), findsOneWidget);

    state.value = const MuEvent.data('Some data');
    await tester.pump();
    expect(state.value.hasData, true);
    expect(find.text('Data'), findsOneWidget);

    state.value = const MuEvent.error('Some error');
    await tester.pump();
    expect(state.value.hasError, true);
    expect(find.text('Error'), findsOneWidget);
  });
}
