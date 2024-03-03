# mu_state

A minimal state solution based on my **Pragmatic state handling in Flutter** 
[Medium article ](https://medium.com/@erlendf/pragmatic-state-handling-in-flutter-d8c9bf5d7d2).

## Features

A set of classes built on `ValueNotifier` and `ValueListenableBuilder` for 
handling state in Flutter.

- `MuEvent<T>` - the base class for our 3 state object
  - `MuEventData<T>` - the data state of type `T`
  - `MuEventError` - the error state
  - `MuEventLoading` - the loading state
- `MuState` - a `ValueNotifier` of type `MuEvent<T>`
- `MuBuilder` - a `ValueListenableBuilder` of type `MuEvent<T>`
- `MuMultiBuilder` - listen to changes in a list of `MuState` objects

## How To

Declare state as a `MuState<T>` variable and pass it an initial `MuEvent` type, 
e.g. a `MuEventLoading` or a `MuEventData<T>`.

For more complex state objects, extend `MuState` and implement the necessary methods.

Listen to `MuState` changes using `MuBuilder`.

Listen to multiple `MuState` objects using `MuMultiBuilder`.

## Example

In `test_state.dart`:

```Dart
import 'package:mu_state/mu_state.dart';

class CounterState extends MuState<int> {
  CounterState(super.initValue);

  void increment() {
    value = MuEventData((value as MuEventData<int>).data + 1);
  }
}

final counterState = CounterState(const MuEventData(0));
```

In `main.dart`:

```Dart
Scaffold(
  body: Center(
    child: MuBuilder(
      state: counterState,
      builder: (context, event, child) {
        return switch (event) {
          MuEventLoading() => const CircularProgressIndicator(),
          MuEventError(error: Object error) => Text('Error: $error'),
          MuEventData(data: int value) => Text('$value')
        };
      },
    ),
  ),
),
```

Also see [Example](./example/).