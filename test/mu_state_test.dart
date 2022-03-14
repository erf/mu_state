import 'package:flutter_test/flutter_test.dart';

import 'package:mu_state/mu_state.dart';

void main() {
  test('create MuState with MuEvent.loading', () {
    final muState = MuState<int>(const MuEvent.loading());
    expect(muState.value.loading, true);
  });

  test('create MuState with MuEvent.loading and data is null', () {
    final muState = MuState<int>(const MuEvent.loading());
    expect(muState.value.data, null);
  });

  test('create MuState with MuEvent.loading and error is null', () {
    final muState = MuState<int>(const MuEvent.loading());
    expect(muState.value.error, null);
  });

  test('create MuState with MuEvent.loading(false)', () {
    final muState = MuState<int>(const MuEvent.loading(false));
    expect(muState.value.loading, false);
  });

  test('create MuState with MuEvent.error', () {
    final muState = MuState<int>(MuEvent.error(AssertionError('Error')));
    expect(muState.value.error, isA<AssertionError>());
  });
}
