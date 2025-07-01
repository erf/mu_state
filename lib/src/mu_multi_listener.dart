import 'package:flutter/widgets.dart';
import 'package:mu_state/mu_state.dart';

/// Signature for the listener builder function used by [MuMultiListener].
typedef MuListenerBuilder = Widget Function(Widget child);

/// A Flutter widget that merges multiple [MuListener] widgets into one.
/// [MuMultiListener] improves the readability and eliminates the need to nest multiple [MuListener]s.
///
/// Example:
/// ```dart
/// MuMultiListener(
///   listeners: [
///     (child) => MuListener<StateA>(
///       logic: logicA,
///       listener: (context, state) {
///         // handle state A changes
///       },
///       child: child,
///     ),
///     (child) => MuListener<StateB>(
///       logic: logicB,
///       listener: (context, state) {
///         // handle state B changes
///       },
///       child: child,
///     ),
///   ],
///   child: ChildWidget(),
/// )
/// ```
class MuMultiListener extends StatelessWidget {
  /// The list of listener builder functions.
  final List<MuListenerBuilder> listeners;

  /// The widget below this widget in the tree.
  final Widget child;

  const MuMultiListener({
    super.key,
    required this.listeners,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return listeners.fold<Widget>(
      child,
      (Widget child, MuListenerBuilder listenerBuilder) {
        return listenerBuilder(child);
      },
    );
  }
}
