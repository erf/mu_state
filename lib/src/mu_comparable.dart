/// A lightweight mixin that provides equality comparison for state objects.
/// This is a minimal alternative to the Equatable package.
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
