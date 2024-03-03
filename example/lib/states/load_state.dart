import 'package:mu_state/mu_state.dart';

class LoadState extends MuState<String> {
  LoadState(super.value);

  void load() async {
    value = const MuEventLoading();
    await Future.delayed(const Duration(milliseconds: 500));
    value = const MuEventData('done');
  }
}

final loadState = LoadState(const MuEventData('initial'));
