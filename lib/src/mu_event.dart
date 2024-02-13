/// [MuEvent] is a sealed class that represents the state of a [MuState].
/// It can be [MuEventLoad], [MuEventError], or [MuEventData].
sealed  class MuEvent {
  const MuEvent();
}

/// [MuEventLoad] is a state that represents the loading state of a [MuState].
class MuEventLoad extends MuEvent {
  const MuEventLoad();
}

/// [MuEventError] is a state that represents the error state of a [MuState].
class MuEventError extends MuEvent {
  final Object error;
  const MuEventError(this.error);
}

/// [MuEventData] is a state that represents the data state of a [MuState].
/// It contains a [value] of type [T].
class MuEventData<T> extends MuEvent {
  final T value;
  const MuEventData(this.value);
}
