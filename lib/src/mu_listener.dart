import 'package:flutter/widgets.dart';
import 'package:mu_state/mu_state.dart';

typedef MuListenerCallback<S> = void Function(BuildContext context, S state);

class MuListener<S> extends StatefulWidget {
  final MuLogic<S> logic;
  final MuListenerCallback<S> listener;
  final Widget child;
  final bool lazy;
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
