import 'package:mu_state/mu_state.dart';

class LoadState extends MuState<String> {
  LoadState(MuEvent<String> value) : super(value);

  void load() async {
    value = const MuEvent.loading();
    await Future.delayed(const Duration(milliseconds: 500));
    value = const MuEvent.data('done');
  }
}

final loadState = LoadState(const MuEvent.data('initial'));
