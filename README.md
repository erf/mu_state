# mu_state

Minimal Cubit-inspired state management using Flutter's built-in primitives. No external dependencies.

> Based on my article [Pragmatic state handling in Flutter](https://medium.com/@erlendf/pragmatic-state-handling-in-flutter-d8c9bf5d7d2)

## Components

- **`MuLogic<T>`** - Alias for `ValueNotifier` to manage state and business logic. Alternative to `Cubit`.
- **`MuBuilder<T>`** - Alias for `ValueListenableBuilder` to rebuild UI on state changes.
- **`MuMultiBuilder`** - Listen to multiple `MuLogic` instances and rebuild when any of them change.
- **`MuProvider<L, S>`** - Provides `MuLogic` instances down the widget tree using `InheritedWidget`.
- **`context.logic<L, S>()`** - Extension method to access `MuLogic` instances from the widget context.
- **`MuComparable`** - Mixin for state classes to enable equality comparisons via `props` list. A lightweight alternative to the `Equatable` package.

## Usage

**Quick workflow:**

1. **Create logic** → Extend `MuLogic<YourState>` with business methods (one per page/feature)
2. **Define state(s)** → Create immutable classes with `MuComparable` and `copyWith()` (can have multiple per page: LoadingState, ErrorState, ReadyState, etc.)
3. **Update state** → Use `value = state.copyWith(...)` (not `emit()`)
4. **Provide logic** → Wrap app with `MuProvider<Logic, State>`
5. **Build UI** → Use `MuBuilder` to listen or `context.logic<T>()` to access

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

See the [example project](example/) for a complete implementation with more features.
