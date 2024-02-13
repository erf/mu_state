import 'package:mu_state/mu_state.dart';

class CounterState extends MuState {
  CounterState(MuEvent initValue) : super(initValue);

  // Increment counter
  void increment() async {
    value = MuEventData((value as MuEventData<int>).value + 1);
  }
}

final counterState = CounterState(const MuEventData<int>(0));
