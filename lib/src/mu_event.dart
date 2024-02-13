/// [MuEvent] is a sealed class that represents the state of a [MuState].
/// It can be [MuEventLoading], [MuEventError], or [MuEventData].
sealed class MuEvent {
  const MuEvent();
}

/// [MuEventLoading] represents a loading state of a [MuState].
class MuEventLoading extends MuEvent {
  const MuEventLoading();
}

/// [MuEventError] represents an error state of a [MuState].
class MuEventError extends MuEvent {
  final Object error;
  const MuEventError(this.error);
}

/// [MuEventData] represents the data state of a [MuState]. It contains [data] of type [T].
class MuEventData<T> extends MuEvent {
  final T data;
  const MuEventData(this.data);
}
