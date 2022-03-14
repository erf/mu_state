# mu_state

A set of helpers for **pragmatic state handling in Flutter** as mentioned in my [Medium article ](https://medium.com/@erlendf/pragmatic-state-handling-in-flutter-d8c9bf5d7d2).

## Classes

A set of classes for handling state based on `ValueNotifier` and
`ValueListenableBuilder`, but by wrapping state in a `MuEvent` object.

- `MuEvent` - state event with `data`, `loading` and `error` properties
- `MuState` - a `ValueNotifier` which holds a `MuEvent`
- `MuBuilder` - a `ValueListenableBuilder` of type `MuEvent`
- `MuMultiBuilder` - listen to multiple `MuState` objects and notify with values 

## Getting started

Declare your state as a global final `MuState` variable and pass it an initial
`MuEvent`. Give it a new `MuEvent` object as the state changes.

Implement your own state class which inherits from `MuState` for more complex
state handling.

Listen to single state objects using `MuBuilder`.

Listen to multiple state objects using `MuMultiBuilder`, which notifies you with
a list of values.

## Usage

In `counter_state.dart`:

```Dart
import 'package:mu_state/mu_state.dart';

class CounterState extends MuState<int> {
  CounterState(MuEvent<int> value) : super(value);

  void increment() {
    value = MuEvent.data(value.data! + 1);
  }
}

final counterState = CounterState(const MuEvent.data(0));
```

In `main.dart`:

```Dart
Scaffold(
	body: Center(
		child: MuBuilder(
			state: counterState,
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

You can find me on Twitter @apptakk
