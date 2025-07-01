import 'package:flutter/widgets.dart';

/// A Flutter widget that makes any value available to descendant widgets via dependency injection.
///
/// [MuProvider] is fully generic and can provide any type - making it perfect for injecting
/// [MuLogic] instances, repositories, services, or other dependencies throughout your widget tree.
///
/// This is purely for dependency injection - it does not rebuild when the value changes.
/// Use [MuBuilder] for listening to state changes.
///
/// ```dart
/// MuProvider<CounterLogic>(
///   value: CounterLogic(),
///   child: CounterPage(),
/// );
/// ```
///
/// Access from anywhere in the subtree:
/// ```dart
/// // For MuLogic instances
/// final logic = context.logic<CounterLogic>();
///
/// // For any type
/// final repo = context.read<AuthRepository>();
/// ```
///
/// If the provided value implements [ChangeNotifier] (like [MuLogic]),
/// it will be automatically disposed when this provider is disposed.
class MuProvider<T> extends StatefulWidget {
  /// Creates a [MuProvider] that provides a value to descendant widgets.
  const MuProvider({
    super.key,
    required this.value,
    required this.child,
  });

  /// The value provided by this provider.
  final T value;

  /// The widget below this widget in the tree.
  final Widget child;

  @override
  State<MuProvider<T>> createState() => _MuProviderState<T>();

  /// Finds the closest [MuProvider] ancestor and returns its value.
  /// Throws if no [MuProvider] of type [T] is found in the widget tree.
  static T of<T>(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<_InheritedMuProvider<T>>();
    if (provider == null) {
      throw FlutterError(
        'MuProvider.of<$T>() called with a context that does not contain a MuProvider of type $T.\n'
        'Make sure that $T is an ancestor of the widget that calls MuProvider.of<$T>()',
      );
    }
    return provider.value;
  }

  /// Finds the closest [MuProvider] ancestor and returns its value, or null if not found.
  static T? maybeOf<T>(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<_InheritedMuProvider<T>>();
    return provider?.value;
  }
}

class _MuProviderState<T> extends State<MuProvider<T>> {
  @override
  void dispose() {
    // Auto-dispose if the value is a ChangeNotifier (like MuLogic)
    if (widget.value is ChangeNotifier) {
      (widget.value as ChangeNotifier).dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedMuProvider<T>(
      value: widget.value,
      child: widget.child,
    );
  }
}

class _InheritedMuProvider<T> extends InheritedWidget {
  const _InheritedMuProvider({
    required this.value,
    required super.child,
  });

  final T value;

  @override
  bool updateShouldNotify(covariant _InheritedMuProvider<T> oldWidget) {
    // Only notify if the value instance changes
    return value != oldWidget.value;
  }
}
