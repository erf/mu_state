# mu_state

A minimal state solution based on my **Pragmatic state handling in Flutter**
[Medium article ](https://medium.com/@erlendf/pragmatic-state-handling-in-flutter-d8c9bf5d7d2).

## Features

A set of classes built on `ValueNotifier` and `ValueListenableBuilder` for
handling state in Flutter.

- `MuLogic` - an alias for `ValueNotifier` where you can optionally use a `MuState<T>` type
- `MuBuilder` - an alias for `ValueListenableBuilder`
- `MuEvent<T>` - the base class for 3 state object which can be used in a `MuState<T>`:
  - `MuEventData<T>` - the data state of type `T`
  - `MuEventError` - the error state
  - `MuEventLoading` - the loading state
- `MuMultiBuilder` - listen to changes of a list of `Listenable` objects

## How To

Contain state by inheriting from `MuLogic` or using it directly. This can have any type.

You can use an optional `MuEvent` type `MuLoading`, `MuError` or `MuData` to contain the state.

Listen to `MuLogic` changes using `MuBuilder`.

Listen to multiple `MuLogic` objects using `MuMultiBuilder`.

## Example

In `test_state.dart`:

```Dart
import 'package:mu_state/mu_state.dart';

class CounterLogic extends MuState<int> {
  CounterLogic(super.initValue);

  void increment() {
    value = value + 1;
  }
}

final counterState = CounterState(0);
```

In `main.dart`:

```Dart
Scaffold(
  body: Center(
    child: MuBuilder(
      state: counterState,
      builder: (context, event, child) {
        return Text('$value');
      },
    ),
  ),
),
```

See more examples in [Example](./example/).
