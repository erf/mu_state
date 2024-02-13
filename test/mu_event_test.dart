import 'package:flutter_test/flutter_test.dart';

import 'package:mu_state/src/mu_event.dart';

void main() {
  test('test MuEventData', () {
    const event = MuEventData('Data');
    expect(event.value, 'Data');
  });

  test('test MuEventError', () {
    final event = MuEventError(AssertionError('Error'));
    expect(event.error, isA<AssertionError>());
  });
}
