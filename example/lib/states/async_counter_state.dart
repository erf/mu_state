import 'dart:math';

import 'package:mu_state/mu_state.dart';

class AsyncCounterState extends MuState<int> {
  AsyncCounterState(MuEvent<int> initValue) : super(initValue);

  // Increment counter, but add a delay and random error.
  void increment() async {
    value = MuEvent(data: value.data, loading: true);
    await Future.delayed(const Duration(milliseconds: 500));
    Random().nextBool()
        ? value = MuEvent(data: value.data! + 1)
        : value = MuEvent(data: value.data, error: 'Random error');
  }
}

final counterState = AsyncCounterState(const MuEvent.data(0));
