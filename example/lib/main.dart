import 'package:flutter/material.dart';
import 'package:mu_state/mu_state.dart';

import 'states/counter_state.dart';
import 'states/load_state.dart';
import 'states/random_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

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
                builder: (context, MuEvent event, child) {
                  return switch (event) {
                    MuEventLoad _ => const CircularProgressIndicator(),
                    MuEventError ev => Text('Error: ${ev.error}'),
                    MuEventData ev => Text('${ev.value}')
                  };
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: MuMultiBuilder(
                states: [counterState, autoCounterState, loadState],
                builder: (context, values, child) {
                  var [counter, autoCounter, load] = values;

                  return Column(
                    children: [
                      Text(
                        'counter: ${switch (counter) {
                          MuEventLoad _ => 'load',
                          MuEventError ev => 'error: ${ev.error}',
                          MuEventData<int> ev => ev.value,
                          _ => '',
                        }}',
                      ),
                      Text(
                        'auto counter: ${switch (autoCounter) {
                          MuEventLoad _ => 'loading',
                          MuEventError ev => 'error: ${ev.error}',
                          MuEventData<int> ev => ev.value,
                          _ => '',
                        }}',
                      ),
                      Text(
                        'load state: ${switch (load) {
                          MuEventLoad _ => 'loading',
                          MuEventError ev => 'error: ${ev.error}',
                          MuEventData<String> ev => ev.value,
                          _ => '',
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
