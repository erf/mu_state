import 'package:mu_state/mu_state.dart';

class CounterState extends MuState<int> {
  CounterState(super.initValue);

  void increment() {
    value = MuEventData((value as MuEventData<int>).data + 1);
  }
}

final counterState = CounterState(const MuEventData(0));
