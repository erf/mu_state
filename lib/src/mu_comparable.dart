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
