import 'package:flutter/widgets.dart';

/// A Flutter widget that merges multiple [MuProvider] widgets into one.
///
/// [MuMultiProvider] improves readability and eliminates the need to nest multiple providers.
/// This is a convenience widget that allows you to compose multiple providers
/// without deeply nested widget trees.
///
/// Instead of nesting providers like this:
/// ```dart
/// MuProvider<LogicA>(
///   value: LogicA(),
///   child: MuProvider<LogicB>(
///     value: LogicB(),
///     child: MuProvider<LogicC>(
///       value: LogicC(),
///       child: ChildWidget(),
///     )
///   )
/// )
/// ```
///
/// You can use [MuMultiProvider]:
/// ```dart
/// MuMultiProvider([
///   (child) => MuProvider<LogicA>(value: LogicA(), child: child),
///   (child) => MuProvider<LogicB>(value: LogicB(), child: child),
///   (child) => MuProvider<LogicC>(value: LogicC(), child: child),
/// ], child: ChildWidget())
/// ```
class MuMultiProvider extends StatelessWidget {
  /// Creates a [MuMultiProvider] using provider builder functions.
  const MuMultiProvider(
    this.providers, {
    super.key,
    required this.child,
  });

  /// The list of provider builder functions.
  final List<Widget Function(Widget child)> providers;

  /// The child widget.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return providers.fold<Widget>(
      child,
      (Widget current, Widget Function(Widget) providerBuilder) {
        return providerBuilder(current);
      },
    );
  }
}
