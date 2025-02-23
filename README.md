# mu_state

A minimal state solution based on my **Pragmatic state handling in Flutter**
[Medium article ](https://medium.com/@erlendf/pragmatic-state-handling-in-flutter-d8c9bf5d7d2).

## Features

A set of classes built on `ValueNotifier` and `ValueListenableBuilder` for
handling state in Flutter.

- `MuState` - an alias for `ValueNotifier` where you can optionally use a `MuEvent<T>` type
- `MuBuilder` - an alias for `ValueListenableBuilder`
- `MuEvent<T>` - the base class for 3 state objects which can be used in a `MuState<T>`:
  - `MuData<T>` - the data state of type `T`
  - `MuError` - the error state
  - `MuLoading` - the loading state
- `MuMultiBuilder` - listen to changes of a list of `Listenable` objects

## How To

Contain state by inheriting from `MuState` or using it directly. This can have any type.

You can optionally use `MuEvent` types: `MuLoading`, `MuError` or `MuData` to contain state.

Listen to `MuState` changes using `MuBuilder`.

Listen to multiple `MuState` objects using `MuMultiBuilder`.

## Example

A simple counter state:

```Dart
import 'package:mu_state/mu_state.dart';

class CounterState extends MuState<int> {
  CounterState(super.initValue);

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
      valueListenable: counterState,
      builder: (context, event, child) {
        return Text('$value');
      },
    ),
  ),
),
```

A state with loading and error handling:

```Dart
class LoadState extends MuState<MuEvent<String>> {
  LoadState(super.value);

  void load() async {
    value = const MuLoading();
    await Future.delayed(const Duration(milliseconds: 500));
    value = const MuData('done');
  }
}

final loadState = LoadState(const MuData('initial'));
```

Handle loading and error states:

```Dart
Scaffold(
  body: Center(
    child: MuBuilder(
      valueListenable: loadState,
      builder: (context, event, child) {
        return switch (event) {
          MuLoading() => const CircularProgressIndicator(),
          MuError() => Text('Error: ${event.error}'),
          MuData() => Text('Data: ${event.data}'),
        };
      },
    ),
  ),
),
```

See more examples in [Example](./example/).
