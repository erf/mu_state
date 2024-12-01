/// [MuEvent] is a sealed class that represents the state of a [MuEvent].
/// It can be [MuLoading], [MuError], or [MuData].
sealed class MuEvent<T> {
  const MuEvent();
}

/// [MuLoading] represents a loading state of a [MuEvent].
class MuLoading<T> extends MuEvent<T> {
  const MuLoading();
}

/// [MuError] represents an error state of a [MuEvent].
class MuError<T> extends MuEvent<T> {
  final Object error;
  const MuError(this.error);
}

/// [MuData] represents the data state of a [MuEvent]. It contains [data] of type [T].
class MuData<T> extends MuEvent<T> {
  final T data;
  const MuData(this.data);
}
