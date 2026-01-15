/// Sealed class for representing async operation states
/// Used for proper state management with Provider
sealed class ResultState<T> {
  const ResultState();
}

/// Initial state before any data is loaded
class ResultStateNone<T> extends ResultState<T> {
  const ResultStateNone();
}

/// Loading state while fetching data
class ResultStateLoading<T> extends ResultState<T> {
  const ResultStateLoading();
}

/// Success state with data
class ResultStateSuccess<T> extends ResultState<T> {
  final T data;
  const ResultStateSuccess(this.data);
}

/// Error state with error message
class ResultStateError<T> extends ResultState<T> {
  final String message;
  const ResultStateError(this.message);
}
