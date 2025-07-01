import 'package:flutter/widgets.dart';
import 'package:mu_state/mu_state.dart';

/// A Flutter widget which combines [MuBuilder] and [MuListener] into one.
///
/// [MuConsumer] exposes a [builder] and [listener] in order to react to new states.
/// [MuConsumer] is analogous to a nested [MuListener] and [MuBuilder] but reduces
/// the amount of boilerplate needed.
///
/// By default, the listener is NOT called on the initial state (`lazy: true`).
/// Set `lazy: false` to call the listener immediately with the current state.
///
/// ```dart
/// MuConsumer<CounterState>(
///   logic: counterLogic,
///   listener: (context, state) {
///     // do stuff here based on state
///   },
///   builder: (context, state, child) {
///     // return widget here based on state
///   },
/// )
/// ```
///
/// An optional [listenWhen] and [buildWhen] can be implemented for more
/// granular control over when [listener] and [builder] are called.
/// The [listenWhen] and [buildWhen] functions take the previous state and the current
/// state and return a [bool] which determines whether or not the [listener] or
/// [builder] function will be invoked.
/// The [listenWhen] and [buildWhen] are optional and if they aren't implemented,
/// they will default to [true].
///
/// ```dart
/// MuConsumer<CounterState>(
///   logic: counterLogic,
///   listenWhen: (previous, current) {
///     // return true/false to determine whether or not
///     // to invoke listener with state
///   },
///   listener: (context, state) {
///     // do stuff here based on state
///   },
///   buildWhen: (previous, current) {
///     // return true/false to determine whether or not
///     // to rebuild the widget with state
///   },
///   builder: (context, state, child) {
///     // return widget here based on state
///   }
/// )
/// ```
class MuConsumer<S> extends StatefulWidget {
  /// The [MuLogic] that the [MuConsumer] will interact with.
  final MuLogic<S> logic;

  /// The [MuListenerCallback] which will be called on every state change.
  /// This [listener] should be used for any code which needs to execute
  /// in response to a state change.
  final MuListenerCallback<S> listener;

  /// The [ValueWidgetBuilder] which will be called on every state change.
  /// This [builder] should be used for any code which needs to rebuild
  /// in response to a state change.
  final ValueWidgetBuilder<S> builder;

  /// An optional [Widget] which is passed to the [builder].
  final Widget? child;

  /// Takes the previous state and the current state and is responsible for
  /// returning a [bool] which determines whether or not to trigger
  /// [listener] with the current state.
  final bool Function(S previous, S current)? listenWhen;

  /// Takes the previous state and the current state and is responsible for
  /// returning a [bool] which determines whether or not to trigger
  /// [builder] with the current state.
  final bool Function(S previous, S current)? buildWhen;

  /// By default, the listener is NOT called on the initial state.
  /// Set [lazy] to false to call the listener immediately with the current state.
  final bool lazy;

  const MuConsumer({
    super.key,
    required this.logic,
    required this.listener,
    required this.builder,
    this.child,
    this.listenWhen,
    this.buildWhen,
    this.lazy = true,
  });

  @override
  State<MuConsumer<S>> createState() => _MuConsumerState<S>();
}

class _MuConsumerState<S> extends State<MuConsumer<S>> {
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
    final shouldBuild = widget.buildWhen?.call(_previous, current) ?? true;

    if (shouldListen) {
      widget.listener(context, current);
    }

    if (shouldBuild) {
      setState(() {});
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
  Widget build(BuildContext context) {
    return widget.builder(context, widget.logic.value, widget.child);
  }
}
