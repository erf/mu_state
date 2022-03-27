import 'package:flutter_test/flutter_test.dart';

import 'package:mu_state/mu_state.dart';

void main() {
  test('create MuEvent.data and other states', () {
    const muState = MuEvent.data('Data');
    expect(muState.data, 'Data');
    expect(muState.hasData, true);
    expect(muState.loading, false);
    expect(muState.hasError, false);
  });

  test('create MuEvent.loading and check loading is true and other states', () {
    const muState = MuEvent.loading();
    expect(muState.loading, true);
    expect(muState.hasData, false);
    expect(muState.hasError, false);
  });

  test('create MuEvent.error and assert it has error and other states', () {
    final muState = MuEvent.error(AssertionError('Error'));
    expect(muState.error, isA<AssertionError>());
    expect(muState.hasError, true);
    expect(muState.hasData, false);
    expect(muState.loading, false);
  });
}
