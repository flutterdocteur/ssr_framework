/// State management interface
abstract class SsrState<T> {
  /// Current state value
  T get state;

  /// Stream of state changes
  Stream<T> get state$;

  /// Dispatch an action to modify state
  void dispatch(dynamic action);
}

/// Action interface for state management
abstract class SsrAction {
  /// Action type
  String get type;

  /// Action payload
  dynamic get payload;
}

/// Base implementation of SsrState
abstract class SsrStateBase<T> implements SsrState<T> {
  @override
  T get state;

  @override
  Stream<T> get state$;

  @override
  void dispatch(dynamic action);
}
