/// [MuEvent] wraps a state [T] with an optional [loading] and [error] status.
class MuEvent<T> {
  final T? data;
  final bool loading;
  final Object? error;

  const MuEvent({
    this.data,
    this.loading = false,
    this.error,
  });

  /// Initializes a [MuEvent] with [data].
  const MuEvent.data(T? data) : this(data: data);

  /// Initializes a [MuEvent] with [loading] set to true by default.
  const MuEvent.loading([bool loading = true]) : this(loading: loading);

  /// Initializes a [MuEvent] with an [error].
  const MuEvent.error(Object error) : this(error: error);

  /// Returns true if [data] is not null.
  bool get hasData => data != null;

  /// Returns true if [error] is not null.
  bool get hasError => error != null;
}
