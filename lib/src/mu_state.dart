import 'package:flutter/foundation.dart';

import 'mu_event.dart';

/// [MuState] is a generalization of [ValueNotifier] with type [MuEvent].
typedef MuState<T> = ValueNotifier<MuEvent<T>>;
