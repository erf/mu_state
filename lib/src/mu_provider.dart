import 'package:flutter/widgets.dart';

/// A provider widget that makes a [ValueNotifier] logic available to descendant
/// widgets.
///
/// This is purely for dependency injection - it does not rebuild when the
/// logic's state changes. Use [MuBuilder] for listening to state changes.
class MuProvider<L extends ValueNotifier<S>, S> extends InheritedWidget {
  /// Creates a [MuProvider] that provides a logic instance to descendant widgets.
  const MuProvider({
    super.key,
    required this.logic,
    required super.child,
  });

  /// The logic instance provided by this provider.
  final L logic;

  @override
  bool updateShouldNotify(covariant MuProvider<L, S> oldWidget) {
    // Only notify if the logic instance changes, not its state
    return logic != oldWidget.logic;
  }

  /// Finds the closest [MuProvider] ancestor and returns its logic.
  /// Throws if no [MuProvider] of type [L] is found in the widget tree.
  static L of<L extends ValueNotifier<S>, S>(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<MuProvider<L, S>>();
    if (provider == null) {
      throw FlutterError(
        'MuProvider.of<$L>() called with a context that does not contain a MuProvider of type $L.\n'
        'Make sure that $L is an ancestor of the widget that calls MuProvider.of<$L>()',
      );
    }
    return provider.logic;
  }

  /// Finds the closest [MuProvider] ancestor and returns its logic, or null if not found.
  static L? maybeOf<L extends ValueNotifier<S>, S>(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<MuProvider<L, S>>();
    return provider?.logic;
  }
}
