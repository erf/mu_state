import 'dart:async';

import 'package:mu_state/mu_state.dart';

class AutoCounterState extends MuState<int> {
  AutoCounterState(MuEvent<int> initValue) : super(initValue) {
    Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      value = MuEvent.data(value.data! + 1);
    });
  }
}

final autoCounterState = AutoCounterState(const MuEvent.data(0));
