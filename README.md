# mu_state

A minimal state solution based on my article [Pragmatic state handling in Flutter](https://medium.com/@erlendf/pragmatic-state-handling-in-flutter-d8c9bf5d7d2) and inspired by **Cubit architecture** using Flutter's built-in primitives.

## Core Components

- **`MuLogic<T>`** - Your business logic class that extends `ValueNotifier`. Contains state and methods to update it.
- **`MuBuilder<T>`** - Rebuilds widgets when state changes. Wrapper around `ValueListenableBuilder`.
- **`MuProvider<L, S>`** - Provides logic instances to the widget tree using `InheritedWidget`. For dependency injection only.
- **`context.logic<L, S>()`** - Retrieves logic from the widget tree. Clean alternative to `Provider.of()`.
- **`MuComparable`** - Mixin for state classes that provides equality comparison to prevent unnecessary rebuilds.
- **`MuMultiBuilder`** - Listen to multiple logic instances simultaneously.

## Example

```dart
import 'package:mu_state/mu_state.dart';

// Simple state class
class CounterState with MuComparable {
  final int counter;
  final bool isLoading;

  const CounterState({required this.counter, required this.isLoading});

  CounterState copyWith({int? counter, bool? isLoading}) {
    return CounterState(
      counter: counter ?? this.counter,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [counter, isLoading];
}

// Logic class
class CounterLogic extends MuLogic<CounterState> {
  CounterLogic() : super(const CounterState(counter: 0, isLoading: false));

  void increment() {
    value = value.copyWith(counter: value.counter + 1);
  }

  Future<void> incrementAsync() async {
    value = value.copyWith(isLoading: true);
    await Future.delayed(const Duration(seconds: 1));
    value = value.copyWith(counter: value.counter + 1, isLoading: false);
  }
}

// Usage
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MuProvider<CounterLogic, CounterState>(
      logic: CounterLogic(),
      child: MaterialApp(
        home: CounterPage(),
      ),
    );
  }
}

class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MuBuilder<CounterState>(
              valueListenable: context.logic<CounterLogic, CounterState>(),
              builder: (context, state, child) {
                return Column(
                  children: [
                    Text('Counter: ${state.counter}'),
                    if (state.isLoading) CircularProgressIndicator(),
                  ],
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.logic<CounterLogic, CounterState>().increment(),
              child: Text('Increment'),
            ),
          ],
        ),
      ),
    );
  }
}
```

> See the [example project](example/) for a complete implementation with more features.
