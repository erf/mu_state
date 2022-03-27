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
}
