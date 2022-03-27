import 'package:flutter_test/flutter_test.dart';

import 'package:mu_state/mu_state.dart';

void main() {
  test('create MuState with MuEvent.data and other states', () {
    final state = MuState(const MuEvent.data('Data'));
    expect(state.value.data, 'Data');
    expect(state.value.hasData, true);
    expect(state.value.loading, false);
    expect(state.value.hasError, false);
  });

  test('create MuEvent.loading and check loading is true and other states', () {
    final state = MuState(const MuEvent.loading());
    expect(state.value.loading, true);
    expect(state.value.hasData, false);
    expect(state.value.hasError, false);
  });

  test('create MuEvent.error and assert it has error and other states', () {
    final state = MuState(MuEvent.error(AssertionError('Error')));
    expect(state.value.error, isA<AssertionError>());
    expect(state.value.hasError, true);
    expect(state.value.hasData, false);
    expect(state.value.loading, false);
  });
}
