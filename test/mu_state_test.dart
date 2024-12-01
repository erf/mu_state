import 'package:flutter_test/flutter_test.dart';
import 'package:mu_state/mu_state.dart';

void main() {
  test('create MuState with MuEvent.data and other states', () {
    final state = MuState(const MuData('data'));
    return switch (state.value) {
      MuData(data: var data) => expect(data, 'data'),
    };
  });

  test('create MuEvent.error and assert it has error and other states', () {
    final state = MuState(MuError(AssertionError('Error')));
    return switch (state.value) {
      MuError(error: var err) => expect(err, isA<AssertionError>()),
    };
  });

  test('create MuEvent.loading and check loading is true and other states', () {
    final state = MuState(const MuLoading());
    return switch (state.value) {
      MuLoading ev => expect(ev, isA<MuLoading>()),
    };
  });
}
