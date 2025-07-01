import 'package:flutter/widgets.dart';
import 'package:mu_state/mu_state.dart';

/// A Flutter widget that listens to multiple [MuLogic] instances and rebuilds when any of them change.
///
/// [MuMultiBuilder] is useful when you need to build UI that depends on multiple state sources.
///
/// ```dart
/// MuMultiBuilder(
///   listenables: [logicA, logicB],
///   builder: (context, values, child) {
///     final stateA = values[0] as StateA;
///     final stateB = values[1] as StateB;
///     return Text('A: ${stateA.value}, B: ${stateB.value}');
///   },
/// )
/// ```
class MuMultiBuilder extends StatelessWidget {
  /// List of [MuLogic] instances to listen to.
  final List<MuLogic> listenables;

  /// The builder function called when any of the [listenables] changes.
  /// It receives the [BuildContext], a list of current state values, and an optional child widget.
  final Widget Function(BuildContext context, List values, Widget? child)
      builder;

  /// An optional child widget that is passed to the [builder] function.
  final Widget? child;

  const MuMultiBuilder({
    super.key,
    required this.listenables,
    required this.builder,
    this.child,
  }) : assert(listenables.length > 0, 'listenables cannot be empty');

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
