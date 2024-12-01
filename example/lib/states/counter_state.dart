import 'package:mu_state/mu_state.dart';

class CounterLogic extends MuLogic<int> {
  CounterLogic(super.initValue);

  void increment() {
    value = value + 1;
  }
}

final counterLogic = CounterLogic(0);
