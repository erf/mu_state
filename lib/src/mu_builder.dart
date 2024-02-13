import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'mu_event.dart';

/// [MuBuilder] is a specialization of [ValueListenableBuilder] with type [MuEvent].
class MuBuilder extends ValueListenableBuilder<MuEvent> {
  const MuBuilder({
    super.key,

    /// The [state] to listen to.
    required ValueListenable<MuEvent> state,

    /// The builder function to call when the [state] changes.
    required super.builder,
  }) : super(valueListenable: state);
}
