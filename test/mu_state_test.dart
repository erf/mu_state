import 'package:flutter_test/flutter_test.dart';

import 'package:mu_state/mu_state.dart';

void main() {
  test('create MuState with MuEvent.data and other states', () {
    final muState = MuState(const MuEvent.data('Data'));
    expect(muState.value.data, 'Data');
    expect(muState.value.hasData, true);
    expect(muState.value.loading, false);
    expect(muState.value.hasError, false);
  });

  test('create MuEvent.loading and check loading is true and other states', () {
    final muState = MuState(const MuEvent.loading());
    expect(muState.value.loading, true);
    expect(muState.value.hasData, false);
    expect(muState.value.hasError, false);
  });

  test('create MuEvent.error and assert it has error and other states', () {
    final muState = MuState(MuEvent.error(AssertionError('Error')));
    expect(muState.value.error, isA<AssertionError>());
    expect(muState.value.hasError, true);
    expect(muState.value.hasData, false);
    expect(muState.value.loading, false);
  });
}
