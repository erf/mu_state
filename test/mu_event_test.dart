import 'package:flutter_test/flutter_test.dart';

import 'package:mu_state/mu_state.dart';

void main() {
  test('create MuEvent.data and other states', () {
    const event = MuEvent.data('Data');
    expect(event.data, 'Data');
    expect(event.hasData, true);
    expect(event.loading, false);
    expect(event.hasError, false);
  });

  test('create MuEvent.loading and check loading is true and other states', () {
    const event = MuEvent.loading();
    expect(event.loading, true);
    expect(event.hasData, false);
    expect(event.hasError, false);
  });

  test('create MuEvent.error and assert it has error and other states', () {
    final event = MuEvent.error(AssertionError('Error'));
    expect(event.error, isA<AssertionError>());
    expect(event.hasError, true);
    expect(event.hasData, false);
    expect(event.loading, false);
  });
}
