import 'package:flutter/material.dart';
import 'package:mu_state/mu_state.dart';

import 'states/auto_counter_state.dart';
import 'states/counter_state.dart';
import 'states/load_state.dart';

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
                valueListenable: counterLogic,
                builder: (context, value, child) => Text('$value'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: MuMultiBuilder(
                listenables: [counterLogic, autoCounterLogic, loadLogic],
                builder: (context, values, child) {
                  return Column(
                    children: [
                      Text('counter: ${counterLogic.value}'),
                      Text('auto counter: ${autoCounterLogic.value}'),
                      Text(
                        'load state: ${switch (loadLogic.value) {
                          MuLoading() => 'loading',
                          MuError(error: Object error) => 'error: $error',
                          MuData(data: String message) => message,
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
          counterLogic.increment();
          loadLogic.load();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
