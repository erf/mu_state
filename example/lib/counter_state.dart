import 'package:mu_state/mu_state.dart';

class CounterState extends MuState<int> {
  CounterState(MuEvent<int> value) : super(value);

  void increment() {
    value = MuEvent.data(value.data! + 1);
  }
}

final counterState = CounterState(const MuEvent.data(0));
