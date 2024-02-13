# mu_state

A minimal state solution based on my **Pragmatic state handling in Flutter** [Medium article ](https://medium.com/@erlendf/pragmatic-state-handling-in-flutter-d8c9bf5d7d2).

## Features

A set of classes built on `ValueNotifier` and `ValueListenableBuilder`. 

- `MuEvent` - the base class for our 3 state object
- `MuEventData` - the data state
- `MuEventError` - the error state
- `MuEventLoading` - the loading state
- `MuState` - a `ValueNotifier` of type `MuEvent`
- `MuBuilder` - a `ValueListenableBuilder` of type `MuEvent`
- `MuMultiBuilder` - listen to a list of `MuState`'s and get notified with a list of `MuEvent`'s 

## How To

Declare state as a global final `MuState` variable and pass it an initial `MuEvent`
type, e.g. a `MuEventLoading` or a `MuEventData`.

Alternatively extend `MuState` and implement the necessary methods.

Listen to `MuState` changes using `MuBuilder`.

Listen to multiple `MuState` objects using `MuMultiBuilder` and handle the list 
of `MuEvent`'s on changes.

## Example

In `test_state.dart`:

```Dart
import 'package:mu_state/mu_state.dart';

class CounterState extends MuState {
  CounterState(MuEvent initValue) : super(initValue);

  void increment() {
    value = MuEventData((value as MuEventData<int>).data + 1);
  }
}

final counterState = CounterState(const MuEventData<int>(0));
```

In `main.dart`:

```Dart
Scaffold(
  body: Center(
    child: MuBuilder(
      state: counterState,
      builder: (context, event, child) {
        return switch (event) {
          MuEventLoading _ => const CircularProgressIndicator(),
          MuEventError ev => Text('Error: ${ev.error}'),
          MuEventData ev => Text('${ev.data}')
        };
      },
    ),
  ),
),
```

Also see [Example](./example/).