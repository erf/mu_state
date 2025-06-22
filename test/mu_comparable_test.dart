import 'package:flutter_test/flutter_test.dart';
import 'package:mu_state/mu_state.dart';

// Test state classes for MuComparable
class SimpleState with MuComparable {
  final int value;
  final String message;

  const SimpleState({required this.value, required this.message});

  @override
  List<Object?> get props => [value, message];
}

class ComplexState with MuComparable {
  final int id;
  final String name;
  final List<String> tags;
  final Map<String, dynamic>? metadata;

  const ComplexState({
    required this.id,
    required this.name,
    required this.tags,
    this.metadata,
  });

  @override
  List<Object?> get props => [id, name, tags, metadata];
}

class EmptyState with MuComparable {
  const EmptyState();

  @override
  List<Object?> get props => [];
}

void main() {
  group('MuComparable Tests', () {
    group('Simple State Comparison', () {
      test('should compare equal states correctly', () {
        const state1 = SimpleState(value: 1, message: 'test');
        const state2 = SimpleState(value: 1, message: 'test');

        expect(state1, equals(state2));
        expect(state1 == state2, isTrue);
      });

      test('should compare different states correctly', () {
        const state1 = SimpleState(value: 1, message: 'test');
        const state2 = SimpleState(value: 2, message: 'test');
        const state3 = SimpleState(value: 1, message: 'different');

        expect(state1, isNot(equals(state2)));
        expect(state1, isNot(equals(state3)));
        expect(state1 == state2, isFalse);
        expect(state1 == state3, isFalse);
        expect(state1, equals(state1));
      });

      test('should generate correct hash codes for equal states', () {
        const state1 = SimpleState(value: 1, message: 'test');
        const state2 = SimpleState(value: 1, message: 'test');

        expect(state1.hashCode, equals(state2.hashCode));
      });

      test('should generate different hash codes for different states', () {
        const state1 = SimpleState(value: 1, message: 'test');
        const state2 = SimpleState(value: 2, message: 'test');

        expect(state1.hashCode, isNot(equals(state2.hashCode)));
      });

      test('should generate correct toString', () {
        const state = SimpleState(value: 42, message: 'hello');
        expect(state.toString(), 'SimpleState(42, hello)');
      });
    });

    group('Complex State Comparison', () {
      test('should compare states with collections correctly', () {
        const state1 = ComplexState(
          id: 1,
          name: 'test',
          tags: ['a', 'b'],
          metadata: {'key': 'value'},
        );
        const state2 = ComplexState(
          id: 1,
          name: 'test',
          tags: ['a', 'b'],
          metadata: {'key': 'value'},
        );
        const state3 = ComplexState(
          id: 1,
          name: 'test',
          tags: ['a', 'c'], // Different tags
          metadata: {'key': 'value'},
        );

        expect(state1, equals(state2));
        expect(state1, isNot(equals(state3)));
      });

      test('should handle null values correctly', () {
        const state1 = ComplexState(
          id: 1,
          name: 'test',
          tags: ['a'],
          metadata: null,
        );
        const state2 = ComplexState(
          id: 1,
          name: 'test',
          tags: ['a'],
          metadata: null,
        );
        const state3 = ComplexState(
          id: 1,
          name: 'test',
          tags: ['a'],
          metadata: {'key': 'value'},
        );

        expect(state1, equals(state2));
        expect(state1, isNot(equals(state3)));
      });

      test('should generate toString with complex data', () {
        const state = ComplexState(
          id: 1,
          name: 'test',
          tags: ['a', 'b'],
          metadata: {'key': 'value'},
        );

        expect(state.toString(), contains('ComplexState'));
        expect(state.toString(), contains('1'));
        expect(state.toString(), contains('test'));
        expect(state.toString(), contains('[a, b]'));
        expect(state.toString(), contains('{key: value}'));
      });
    });

    group('Empty State', () {
      test('should compare empty states correctly', () {
        const state1 = EmptyState();
        const state2 = EmptyState();

        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
      });

      test('should generate toString for empty state', () {
        const state = EmptyState();
        expect(state.toString(), 'EmptyState()');
      });
    });

    group('Cross-type Comparison', () {
      test('should not equal states of different types', () {
        const simpleState = SimpleState(value: 1, message: 'test');
        const emptyState = EmptyState();

        expect(simpleState, isNot(equals(emptyState)));
      });
    });
  });
}
