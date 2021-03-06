# mu_state

A set of helpers for **pragmatic state handling in Flutter** as mentioned in my [Medium article ](https://medium.com/@erlendf/pragmatic-state-handling-in-flutter-d8c9bf5d7d2).

## Features

A set of classes for handling state based on `ValueNotifier` and `ValueListenableBuilder`, where state is wrapped in a `MuEvent` object:

- `MuEvent` - state event with `data`, `loading` and `error` fields
- `MuState` - a `ValueNotifier` of type `MuEvent`
- `MuBuilder` - a `ValueListenableBuilder` of type `MuEvent`
- `MuMultiBuilder` - listen to multiple `MuState` objects and get notified with a list of `MuEvent` values 

## Getting started

Declare state as a global final `MuState` variable and pass it an initial
`MuEvent`. Add new `MuEvent` objects to `MuState.value` as state changes.

For more complex state handling, extends `MuState` and implement the necessary
logic / methods.

Listen to a single `MuState` object using `MuBuilder`.

Listen to multiple `MuState` objects using `MuMultiBuilder`, which notifies you
with a list of `MuEvent` values on every state change.

## Example

In `test_state.dart`:

```Dart
import 'package:mu_state/mu_state.dart';

class TestState extends MuState<String> {
  TestState(MuEvent<String> value) : super(value);

  void load() async {
    value = const MuEvent.loading();
    await Future.delayed(const Duration(milliseconds: 500));
    value = const MuEvent.data('done');
  }
}

final testState = TestState(const MuEvent.data('initial'));
```

In `main.dart`:

```Dart
Scaffold(
  body: Center(
    child: MuBuilder<String>(
      state: testState,
      builder: (context, event, child) {
        if (event.loading) {
          return const CircularProgressIndicator();
        }
        if (event.hasError) {
          return Text('Error: ${event.error.toString()}');
        }
        return Text('${event.data}');
      },
    ),
  ),
),
```

Also see [Example](./example/).

## Additional information

I'd like to keep this packages minimal, but please create an issue if you have a
suggestion.

I'm on Twitter as @apptakk

