import 'package:mu_state/mu_state.dart';

class CounterState extends MuState<int> {
  CounterState(super.initValue);

  void increment() {
    value = value + 1;
  }
}

final counterState = CounterState(0);
