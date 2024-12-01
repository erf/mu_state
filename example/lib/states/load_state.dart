import 'package:mu_state/mu_state.dart';

class LoadState extends MuLogic<MuState<String>> {
  LoadState(super.value);

  void load() async {
    value = const MuLoading();
    await Future.delayed(const Duration(milliseconds: 500));
    value = const MuData('done');
  }
}

final loadLogic = LoadState(const MuData('initial'));
