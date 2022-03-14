library mu_state;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// [MuEvent] wraps a state [T] with an optional [loading] and [error] status.
class MuEvent<T> {
  final T? data;
  final bool loading;
  final Object? error;

  const MuEvent({
    this.data,
    this.loading = false,
    this.error,
  });

  /// Initializes a [MuEvent] with [data].
  const MuEvent.data(T? data) : this(data: data);

  /// Initializes a [MuEvent] with [loading] set to true by default.
  const MuEvent.loading([bool loading = true]) : this(loading: loading);

  /// Initializes a [MuEvent] with an [error].
  const MuEvent.error(Object error) : this(error: error);

  /// Returns true if [data] is not null.
  bool get hasData => data != null;

  /// Returns true if [error] is not null.
  bool get hasError => error != null;
}

/// [MuState] is a generalization of [ValueNotifier] with type [MuEvent].
typedef MuState<T> = ValueNotifier<MuEvent<T>>;

/// [MuBuilder] is a specialization of [ValueListenableBuilder] with type [MuEvent].
class MuBuilder<T> extends ValueListenableBuilder<MuEvent<T>> {
  const MuBuilder({
    Key? key,

    /// The [state] to listen to.
    required ValueListenable<MuEvent<T>> state,

    /// The builder function to call when the [state] changes.
    required ValueWidgetBuilder<MuEvent<T>> builder,
  }) : super(key: key, valueListenable: state, builder: builder);
}

/// Listen to multiple [MuState]s and get notified with a list of values.
class MuMultiBuilder extends StatelessWidget {
  /// List of [MuState]s to listen to.
  final List<MuState> states;

  /// The builder function is called when the value of any of the [states] changes.
  /// The order of the values will be same as the [states] list.
  final Widget Function(
      BuildContext context, List<MuEvent> values, Widget? child) builder;

  /// An optional [child] widget will passed to [builder].
  final Widget? child;

  const MuMultiBuilder({
    Key? key,

    /// List of [MuState]s to listen to.
    required this.states,

    /// The builder function is called when the value of any of the [states] changes.
    required this.builder,
    this.child,
  })  : assert(states.length != 0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge(states),
      builder: (BuildContext context, Widget? child) {
        return builder(
          context,
          states.map((listenable) => listenable.value).toList(growable: false),
          child,
        );
      },
      child: child,
    );
  }
}
