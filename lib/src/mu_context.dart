import 'package:flutter/widgets.dart';
import 'package:mu_state/mu_state.dart';

/// Extension on [BuildContext] to provide convenient access to logic instances.
extension MuContext on BuildContext {
  /// Finds the closest [MuProvider] ancestor and returns its logic.
  /// Throws if no [MuProvider] of type [L] is found in the widget tree.
  ///
  /// Usage: `context.logic<CounterLogic, CounterState>()`
  L logic<L extends MuLogic<S>, S>() {
    return MuProvider.of<L, S>(this);
  }

  /// Finds the closest [MuProvider] ancestor and returns its logic, or null if not found.
  ///
  /// Usage: `context.maybeLogic<CounterLogic, CounterState>()`
  L? maybeLogic<L extends MuLogic<S>, S>() {
    return MuProvider.maybeOf<L, S>(this);
  }
}
