/// A lightweight mixin that provides equality comparison for state classes.
///
/// [MuComparable] is a minimal alternative to packages like Equatable and helps
/// [MuBuilder] and other listeners determine when to rebuild by providing proper
/// equality semantics for state objects.
///
/// ```dart
/// class CounterState with MuComparable {
///   final int counter;
///   final String? error;
///
///   const CounterState({required this.counter, this.error});
///
///   @override
///   List<Object?> get props => [counter, error];
/// }
/// ```
///
/// The [props] list should include all properties that determine equality.
/// When state changes, widgets will only rebuild if the new state is different
/// from the previous state based on these properties.
///
/// ## Equality is shallow
///
/// Each entry in [props] is compared using Dart's default `==` operator.
/// For primitive values (`int`, `String`, `bool`, `enum`, etc.) this is
/// content-based and works as expected. For collections (`List`, `Map`, `Set`)
/// Dart's default `==` is **identity-based** — two collections with the same
/// contents but different instances are considered unequal.
///
/// ⚠️ **Important:** never mutate a collection in place and re-emit the same
/// state object. Equality will return `true`, listeners will not fire, and
/// widgets will not rebuild. Always create a *new* collection when updating
/// state:
///
/// ```dart
/// // ✅ Correct — produces a new list, triggers rebuilds.
/// emit(state.copyWith(items: [...state.items, newItem]));
///
/// // ✅ Correct — new map.
/// emit(state.copyWith(tags: {...state.tags, 'k': 'v'}));
///
/// // ❌ Wrong — mutates in place, same reference, no rebuild.
/// state.items.add(newItem);
/// emit(state.copyWith(items: state.items));
/// ```
///
/// This copy-on-write discipline is standard practice for immutable state
/// and matches conventions used by `bloc` / `Equatable`.
///
/// If you need deep collection equality out of the box, consider using
/// [Equatable](https://pub.dev/packages/equatable) instead of this mixin.
mixin MuComparable {
  /// The list of properties that will be used to determine whether
  /// two instances are equal.
  List<Object?> get props;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is! MuComparable) return false;

    if (runtimeType != other.runtimeType) return false;

    final List<Object?> otherProps = other.props;
    if (props.length != otherProps.length) return false;

    for (int i = 0; i < props.length; i++) {
      if (props[i] != otherProps[i]) return false;
    }

    return true;
  }

  @override
  int get hashCode => Object.hashAll(props);

  @override
  String toString() => '$runtimeType(${props.join(', ')})';
}
