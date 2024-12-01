import 'package:flutter/widgets.dart';

import 'mu_logic.dart';
import 'mu_state.dart';

/// Listen to a list of [MuLogic] objects and get notified on any change.
class MuMultiBuilder extends StatelessWidget {
  /// List of [MuLogic]s to listen to.
  final List<MuLogic> listenables;

  /// The builder is called when the value of any of the [listenables] changes and is
  /// passed the [BuildContext] and the list of [MuState]s.
  final Widget Function(BuildContext context, List values, Widget? child)
      builder;

  /// An optional [child] widget will passed to [builder].
  final Widget? child;

  const MuMultiBuilder({
    super.key,

    /// List of [MuLogic] classes to listen to.
    required this.listenables,

    /// The builder function is called when the value of any of the [states] changes.
    required this.builder,
    this.child,
  }) : assert(listenables.length != 0);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge(listenables),
      builder: (BuildContext context, Widget? child) => builder(
        context,
        listenables.map((listenable) => listenable.value).toList(),
        child,
      ),
      child: child,
    );
  }
}
