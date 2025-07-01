import 'package:flutter/widgets.dart';
import 'package:mu_state/mu_state.dart';

typedef MuListenerCallback<S> = void Function(BuildContext context, S state);

/// A Flutter widget that performs side effects in response to state changes.
///
/// [MuListener] is useful for performing side effects like navigation,
/// showing dialogs, or any other actions that should happen in response
/// to state changes but don't require rebuilding the UI.
///
/// ```dart
/// MuListener<CounterState>(
///   logic: logic,
///   listener: (context, state) {
///     if (state.error != null) {
///       ScaffoldMessenger.of(context).showSnackBar(
///         SnackBar(content: Text('Error: ${state.error}')),
///       );
///     }
///   },
///   listenWhen: (prev, curr) => prev.error != curr.error,
///   child: Container(),
/// )
/// ```
class MuListener<S> extends StatefulWidget {
  /// The [MuLogic] that this listener will listen to.
  final MuLogic<S> logic;

  /// The callback that will be called when the state changes.
  final MuListenerCallback<S> listener;

  /// The widget below this widget in the tree.
  final Widget child;

  /// Whether to call the listener immediately with the current state.
  /// If true (default), the listener is only called on state changes.
  /// If false, the listener is called immediately with the initial state.
  final bool lazy;

  /// An optional condition to determine when the listener should be called.
  /// If null, the listener is called on every state change.
  final bool Function(S previous, S current)? listenWhen;

  const MuListener({
    super.key,
    required this.logic,
    required this.listener,
    required this.child,
    this.lazy = true,
    this.listenWhen,
  });

  @override
  State<MuListener<S>> createState() => _MuListenerState<S>();
}

class _MuListenerState<S> extends State<MuListener<S>> {
  late S _previous;

  @override
  void initState() {
    super.initState();
    _previous = widget.logic.value;
    widget.logic.addListener(_onChange);

    if (!widget.lazy) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.listener(context, _previous);
      });
    }
  }

  void _onChange() {
    final current = widget.logic.value;
    final shouldListen = widget.listenWhen?.call(_previous, current) ?? true;

    if (shouldListen) {
      widget.listener(context, current);
    }

    // Always update _previous to reflect the actual previous state
    _previous = current;
  }

  @override
  void dispose() {
    widget.logic.removeListener(_onChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
