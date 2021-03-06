import 'package:flutter/widgets.dart';

import 'mu_event.dart';
import 'mu_state.dart';

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
