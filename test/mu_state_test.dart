import 'package:flutter_test/flutter_test.dart';

import 'package:mu_state/mu_state.dart';

void main() {
  test('create MuState with MuEvent.data and other states', () {
    final state = MuState(const MuEventData('data'));
    return switch (state.value) {
      MuEventData(data: var data) => expect(data, 'data'),
      _ => fail('Invalid state'),
    };
  });

  test('create MuEvent.error and assert it has error and other states', () {
    final state = MuState(MuEventError(AssertionError('Error')));
    return switch (state.value) {
      MuEventError(error: var err) => expect(err, isA<AssertionError>()),
      _ => fail('Invalid state'),
    };
  });

  test('create MuEvent.loading and check loading is true and other states', () {
    final state = MuState(const MuEventLoading());
    return switch (state.value) {
      MuEventLoading ev => expect(ev, isA<MuEventLoading>()),
      _ => fail('Invalid state'),
    };
  });
}
