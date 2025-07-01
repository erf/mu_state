import 'package:flutter/foundation.dart';

/// A typedef for [ValueNotifier] that serves as the foundation for business logic.
///
/// [MuLogic] manages state and notifies listeners when the state changes.
/// It's essentially an alias that makes the code more semantic for state management purposes.
///
/// ```dart
/// class CounterLogic extends MuLogic<CounterState> {
///   CounterLogic() : super(const CounterState(counter: 0));
///
///   void increment() {
///     value = value.copyWith(counter: value.counter + 1);
///   }
/// }
/// ```
///
/// Since [MuLogic] extends [ValueNotifier], you get all the familiar methods like
/// `addListener`, `removeListener`, and the `value` property for getting and setting state.
typedef MuLogic<S> = ValueNotifier<S>;
