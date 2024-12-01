/// [MuState] is a sealed class that represents the state of a [MuState].
/// It can be [MuLoading], [MuError], or [MuData].
sealed class MuState<T> {
  const MuState();
}

/// [MuLoading] represents a loading state of a [MuState].
class MuLoading<T> extends MuState<T> {
  const MuLoading();
}

/// [MuError] represents an error state of a [MuState].
class MuError<T> extends MuState<T> {
  final Object error;
  const MuError(this.error);
}

/// [MuData] represents the data state of a [MuState]. It contains [data] of type [T].
class MuData<T> extends MuState<T> {
  final T data;
  const MuData(this.data);
}
