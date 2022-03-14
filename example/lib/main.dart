import 'package:flutter/material.dart';
import 'package:mu_state/mu_state.dart';

import 'states/async_counter_state.dart';
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
                builder: (context, event, child) {
                  if (event.loading) {
                    return const CircularProgressIndicator();
                  }
                  if (event.hasError) {
                    return Text(
                      'Error: ${event.error.toString()}',
                      style: const TextStyle(
                        color: Colors.redAccent,
                      ),
                    );
                  }
                  return Text(
                    '${event.data}',
                    style: Theme.of(context).textTheme.headline4,
                  );
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
                        'counter: ${values[0].data}',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      Text(
                        'auto counter: ${values[1].data}',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      Text(
                        'load state: ${values[2].loading ? 'loading' : values[2].data}',
                        style: Theme.of(context).textTheme.headline4,
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
