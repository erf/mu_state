import 'package:flutter/widgets.dart';
import 'package:mu_state/mu_state.dart';

/// Extension on [BuildContext] to provide convenient access to logic instances.
extension MuContext on BuildContext {
  /// Finds the closest [MuProvider] ancestor and returns its logic.
  /// Throws if no [MuProvider] of type [L] is found in the widget tree.
  ///
  /// Usage: `context.logic<CounterLogic>()`
  L logic<L extends MuLogic>() {
    return MuProvider.of<L>(this);
  }

  /// Finds the closest [MuProvider] ancestor and returns its logic, or null if not found.
  ///
  /// Usage: `context.maybeLogic<CounterLogic>()`
  L? maybeLogic<L extends MuLogic>() {
    return MuProvider.maybeOf<L>(this);
  }

  /// Finds the closest [MuProvider] ancestor and returns its value.
  /// Throws if no [MuProvider] of type [T] is found in the widget tree.
  ///
  /// Usage: `context.read<UserRepository>()`
  T read<T>() {
    return MuProvider.of<T>(this);
  }

  /// Finds the closest [MuProvider] ancestor and returns its value, or null if not found.
  ///
  /// Usage: `context.maybeRead<UserRepository>()`
  T? maybeRead<T>() {
    return MuProvider.maybeOf<T>(this);
  }
}
