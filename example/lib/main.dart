import 'package:flutter/material.dart';
import 'package:mu_state/mu_state.dart';

import 'states/counter_state.dart';
import 'states/load_state.dart';
import 'states/auto_counter_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('mu_state example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: MuBuilder(
                state: counterState,
                builder: (context, event, child) {
                  return switch (event) {
                    MuEventLoading() => const CircularProgressIndicator(),
                    MuEventError(error: Object error) => Text('Error: $error'),
                    MuEventData(data: int data) => Text('$data')
                  };
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: MuMultiBuilder(
                states: [counterState, autoCounterState, loadState],
                builder: (context, values, child) {
                  return Column(
                    children: [
                      Text(
                        'counter: ${switch (counterState.value) {
                          MuEventLoading() => 'load',
                          MuEventError(error: Object error) => 'error: $error',
                          MuEventData(data: int value) => value,
                        }}',
                      ),
                      Text(
                        'auto counter: ${switch (autoCounterState.value) {
                          MuEventLoading() => 'loading',
                          MuEventError(error: Object error) => 'error: $error',
                          MuEventData(data: int value) => value,
                          _ => '',
                        }}',
                      ),
                      Text(
                        'load state: ${switch (loadState.value) {
                          MuEventLoading() => 'loading',
                          MuEventError(error: Object error) => 'error: $error',
                          MuEventData(data: String message) => message,
                        }}',
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          counterState.increment();
          loadState.load();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
