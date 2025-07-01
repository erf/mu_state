# mu_state

Minimal Cubit-inspired state management using Flutter's built-in primitives. No external dependencies.

> See my article [From ValueNotifier to Cubit-inspired state management](https://medium.com/@erlendf/from-valuenotifier-to-cubit-inspired-a-pragmatic-evolution-80eea6dba605) for more info

## Overview

`mu_state` provides a lightweight alternative to Bloc/Cubit using Flutter's built-in `ValueNotifier` and `InheritedWidget`. It follows the same patterns you know from Bloc but with zero dependencies and minimal boilerplate.

**Key concepts:**

- **`MuLogic<S>`** - Your business logic (like `Cubit`)
- **`MuBuilder<S>`** - Rebuilds UI on state changes (like `BlocBuilder`)
- **`MuListener<S>`** - Performs side effects (like `BlocListener`)
- **`MuConsumer<S>`** - Combines builder and listener (like `BlocConsumer`)
- **`MuProvider<L,S>`** - Provides logic down the widget tree (like `BlocProvider`)

## Usage

Let's create a simple counter to see how `mu_state` works:

### counter_logic.dart

```dart
import 'package:mu_state/mu_state.dart';

class CounterState with MuComparable {
  final int counter;
  final bool isLoading;
  final String? error;

  const CounterState({required this.counter, required this.isLoading, this.error});

  CounterState copyWith({int? counter, bool? isLoading, String? error}) {
    return CounterState(
      counter: counter ?? this.counter,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [counter, isLoading, error];
}

class CounterLogic extends MuLogic<CounterState> {
  CounterLogic() : super(const CounterState(counter: 0, isLoading: false));

  void increment() {
    value = value.copyWith(counter: value.counter + 1);
  }

  Future<void> incrementAsync() async {
    value = value.copyWith(isLoading: true, error: null);
    await Future.delayed(const Duration(seconds: 1));
    
    // Simulate random error
    if (DateTime.now().millisecondsSinceEpoch % 3 == 0) {
      value = value.copyWith(isLoading: false, error: 'Failed to increment');
    } else {
      value = value.copyWith(counter: value.counter + 1, isLoading: false);
    }
  }
}
```

### main.dart

```dart
import 'package:flutter/material.dart';
import 'package:mu_state/mu_state.dart';
import 'counter_logic.dart';

void main() => runApp(CounterApp());

class CounterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MuProvider<CounterLogic, CounterState>(
        logic: CounterLogic(),
        child: CounterPage(),
      ),
    );
  }
}
```

### counter_page.dart

```dart
class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final logic = context.logic<CounterLogic, CounterState>();
    
    return Scaffold(
      appBar: AppBar(title: Text('Counter')),
      body: MuListener<CounterState>(
        logic: logic,
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('⚠️ ${state.error}')),
            );
          }
        },
        listenWhen: (prev, curr) => prev.error != curr.error && curr.error != null,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MuBuilder<CounterState>(
                valueListenable: logic,
                builder: (context, state, child) {
                  return Column(
                    children: [
                      Text('Counter: ${state.counter}', style: Theme.of(context).textTheme.headlineMedium),
                      if (state.isLoading) CircularProgressIndicator(),
                    ],
                  );
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => logic.increment(),
                child: Text('Increment'),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => logic.incrementAsync(),
                child: Text('Async Increment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

At this point we have successfully separated our presentational layer from our business logic layer. Notice that `CounterPage` knows nothing about what happens when a user taps the buttons. The widget simply notifies the `CounterLogic` that the user has pressed increment.

> **Alternative:** You could also use `MuConsumer` to combine the listener and builder functionality:
> ```dart
> MuConsumer<CounterState>(
>   logic: logic,
>   listener: (context, state) {
>     if (state.error != null) {
>       ScaffoldMessenger.of(context).showSnackBar(
>         SnackBar(content: Text('⚠️ ${state.error}')),
>       );
>     }
>   },
>   listenWhen: (prev, curr) => prev.error != curr.error && curr.error != null,
>   builder: (context, state, child) {
>     return Column(
>       children: [
>         Text('Counter: ${state.counter}'),
>         if (state.isLoading) CircularProgressIndicator(),
>         SizedBox(height: 20),
>         ElevatedButton(
>           onPressed: () => logic.increment(),
>           child: Text('Increment'),
>         ),
>         // ... rest of buttons
>       ],
>     );
>   },
> )
> ```

## Components

### MuLogic

`MuLogic<S>` is a typedef for `ValueNotifier<S>` that serves as the foundation for your business logic. It manages state and notifies listeners when the state changes. `MuLogic` is essentially an alias that makes the code more semantic for state management purposes.

```dart
// MuLogic<S> is just a typedef for ValueNotifier<S>
class CounterLogic extends MuLogic<CounterState> {
  CounterLogic() : super(const CounterState(counter: 0, isLoading: false));

  void increment() {
    value = value.copyWith(counter: value.counter + 1);
  }
}
```

Since `MuLogic` extends `ValueNotifier`, you get all the familiar methods like `addListener`, `removeListener`, and the `value` property for getting and setting state.

### MuBuilder

`MuBuilder<S>` is a typedef for `ValueListenableBuilder<S>` that rebuilds the widget when the state changes. It's essentially an alias that makes the code more semantic for state management, but underneath it's just Flutter's built-in `ValueListenableBuilder`.

See `MuListener` if you want to "do" anything in response to state changes such as navigation, showing a dialog, etc...

```dart
// MuBuilder<S> is just a typedef for ValueListenableBuilder<S>
MuBuilder<CounterState>(
  valueListenable: logic,
  builder: (context, state, child) {
    // return widget here based on state
    return Text('Counter: ${state.counter}');
  }
)
```

### MuListener

`MuListener` is a Flutter widget which takes a `listener` and a `logic` and invokes the `listener` in response to state changes in the logic. It should be used for functionality that needs to occur once per state change such as navigation, showing a `SnackBar`, showing a `Dialog`, etc...

`listener` is only called once for each state change and is a `void` function, unlike `builder` in `MuBuilder`. By default, the listener is NOT called on the initial state (`lazy: true`), but you can set `lazy: false` to call the listener immediately with the current state.

```dart
MuListener<CounterState>(
  logic: logic,
  listener: (context, state) {
    if (state.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${state.error}')),
      );
    }
  },
  child: Container(),
)
```

For fine-grained control over when the `listener` function is called an optional `listenWhen` can be provided. `listenWhen` takes the previous state and current state and returns a boolean. If `listenWhen` returns true, `listener` will be called with `state`. If `listenWhen` returns false, `listener` will not be called with `state`.

```dart
MuListener<CounterState>(
  listenWhen: (previousState, state) {
    // return true/false to determine whether or not
    // to call listener with state
    return previousState.error != state.error;
  },
  listener: (context, state) {
    // do stuff here based on state
  },
  child: Container(),
)
```

### MuProvider

`MuProvider` is a Flutter widget which provides a logic instance to its children via `context.logic<T>()`. It is used as a dependency injection (DI) widget so that a single instance of a logic can be provided to multiple widgets within a subtree.

In most cases, `MuProvider` should be used to create new logic instances which will be made available to the rest of the subtree. In this case, since `MuProvider` is responsible for creating the logic, it will automatically handle disposing it.

```dart
MuProvider<CounterLogic, CounterState>(
  logic: CounterLogic(),
  child: CounterPage(),
);
```

then from `CounterPage` we can retrieve the `CounterLogic` instance with:

```dart
// Access the logic
final logic = context.logic<CounterLogic, CounterState>();

// Use the logic
logic.increment();
```

### MuMultiProvider

`MuMultiProvider` is a Flutter widget that merges multiple `MuProvider` widgets into one. `MuMultiProvider` improves the readability and eliminates the need to nest multiple `MuProviders`. By using `MuMultiProvider` we can go from:

```dart
MuProvider<LogicA, StateA>(
  logic: LogicA(),
  child: MuProvider<LogicB, StateB>(
    logic: LogicB(),
    child: MuProvider<LogicC, StateC>(
      logic: LogicC(),
      child: ChildA(),
    )
  )
)
```

to:

```dart
MuMultiProvider([
  (child) => MuProvider<LogicA, StateA>(logic: LogicA(), child: child),
  (child) => MuProvider<LogicB, StateB>(logic: LogicB(), child: child),
  (child) => MuProvider<LogicC, StateC>(logic: LogicC(), child: child),
], child: ChildA())
```

### MuMultiBuilder

`MuMultiBuilder` is a Flutter widget which listens to multiple `MuLogic` instances and rebuilds when any of them change. This is useful when you need to build UI that depends on multiple state sources.

```dart
MuMultiBuilder(
  valueListenables: [logicA, logicB],
  builder: (context, values, child) {
    final stateA = values[0] as StateA;
    final stateB = values[1] as StateB;
    return Text('A: ${stateA.value}, B: ${stateB.value}');
  },
)
```

### MuMultiListener

`MuMultiListener` is a Flutter widget that merges multiple `MuListener` widgets into one. `MuMultiListener` improves the readability and eliminates the need to nest multiple `MuListener`s. By using `MuMultiListener` we can go from:

```dart
MuListener<StateA>(
  logic: logicA,
  listener: (context, state) {
    // handle state A changes
  },
  child: MuListener<StateB>(
    logic: logicB,
    listener: (context, state) {
      // handle state B changes
    },
    child: ChildWidget(),
  ),
)
```

to:

```dart
MuMultiListener(
  listeners: [
    (child) => MuListener<StateA>(
      logic: logicA,
      listener: (context, state) {
        // handle state A changes
      },
      child: child,
    ),
    (child) => MuListener<StateB>(
      logic: logicB,
      listener: (context, state) {
        // handle state B changes
      },
      child: child,
    ),
  ],
  child: ChildWidget(),
)
```

### MuConsumer

`MuConsumer` is a Flutter widget which combines `MuBuilder` and `MuListener` into one. `MuConsumer` exposes a `builder` and `listener` in order to react to new states. `MuConsumer` is analogous to a nested `MuListener` and `MuBuilder` but reduces the amount of boilerplate needed.

```dart
MuConsumer<CounterState>(
  logic: logic,
  listener: (context, state) {
    if (state.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${state.error}')),
      );
    }
  },
  builder: (context, state, child) {
    return Text('Counter: ${state.counter}');
  },
)
```

An optional `listenWhen` and `buildWhen` can be implemented for more granular control over when `listener` and `builder` are called. The `listenWhen` and `buildWhen` functions take the previous state and the current state and return a `bool` which determines whether or not the `listener` or `builder` function will be invoked.

```dart
MuConsumer<CounterState>(
  logic: logic,
  listenWhen: (previous, current) {
    // return true/false to determine whether or not
    // to invoke listener with state
    return previous.error != current.error;
  },
  listener: (context, state) {
    // do stuff here based on state
  },
  buildWhen: (previous, current) {
    // return true/false to determine whether or not
    // to rebuild the widget with state
    return previous.counter != current.counter;
  },
  builder: (context, state, child) {
    // return widget here based on state
    return Text('Counter: ${state.counter}');
  }
)
```

See the [example project](example/) for a complete implementation with more features.
