import 'package:flutter/widgets.dart';

/// A widget that provides multiple providers down the widget tree.
///
/// This is a convenience widget that allows you to nest multiple providers
/// without deeply nested widget trees.
///
/// Usage:
/// ```dart
/// MuMultiProvider([
///   (child) => MuProvider<AuthLogic, AuthState>(logic: authLogic, child: child),
///   (child) => MuProvider<LoginLogic, LoginState>(logic: loginLogic, child: child),
/// ], child: LoginPage())
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
