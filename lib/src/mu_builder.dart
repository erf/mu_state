import 'package:flutter/widgets.dart';

/// A typedef for [ValueListenableBuilder] that rebuilds widgets when state changes.
///
/// [MuBuilder] is essentially an alias that makes the code more semantic for state management,
/// but underneath it's just Flutter's built-in [ValueListenableBuilder].
///
/// ```dart
/// MuBuilder<CounterState>(
///   valueListenable: logic,
///   builder: (context, state, child) {
///     return Text('Counter: ${state.counter}');
///   }
/// )
/// ```
///
/// See [MuListener] if you want to perform side effects in response to state changes
/// such as navigation, showing dialogs, etc.
typedef MuBuilder<L> = ValueListenableBuilder<L>;
