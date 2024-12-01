import 'dart:async';

import 'package:mu_state/mu_state.dart';

class AutoCounterState extends MuState<int> {
  AutoCounterState(super.initValue) {
    Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      value = value + 1;
    });
  }
}

final autoCounterState = AutoCounterState(0);
