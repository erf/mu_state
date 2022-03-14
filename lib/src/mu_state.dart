import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'mu_event.dart';

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
