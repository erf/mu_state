import 'package:flutter_test/flutter_test.dart';
import 'package:mu_state/src/mu_state.dart';

void main() {
  test('test MuEventData', () {
    const event = MuData('Data');
    expect(event.data, 'Data');
  });

  test('test MuEventError', () {
    final event = MuError(AssertionError('Error'));
    expect(event.error, isA<AssertionError>());
  });
}
