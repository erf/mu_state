import 'package:mu_state/mu_state.dart';

class LoadState extends MuState {
  LoadState(MuEvent value) : super(value);

  void load() async {
    value = const MuEventLoad();
    await Future.delayed(const Duration(milliseconds: 500));
    value = const MuEventData('done');
  }
}

final loadState = LoadState(const MuEventData('initial'));
