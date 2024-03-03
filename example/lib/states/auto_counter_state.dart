import 'dart:async';

//import 'package:mu_state/mu_state.dart';
import 'package:mu_state/mu_state.dart';

class AutoCounterState extends MuState<int> {
  AutoCounterState(MuEventData<int> super.initValue) {
    Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      value = MuEventData((value as MuEventData<int>).data + 1);
    });
  }
}

final autoCounterState = AutoCounterState(const MuEventData(0));
