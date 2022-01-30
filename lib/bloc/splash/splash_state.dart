part of 'splash_cubit.dart';

class SplashState {
  final SplashStatus _status;
  final String? _error;

  const SplashState({
    SplashStatus status = SplashStatus.initial,
    String? error,
  })  : _status = status,
        _error = error;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SplashState &&
          runtimeType == other.runtimeType &&
          _status == other._status &&
          _error == other._error;

  @override
  int get hashCode => _status.hashCode ^ _error.hashCode;

  SplashStatus get status => _status;

  String? get error => _error;

  @override
  String toString() {
    return 'SplashState{_status: $_status, _error: $_error}';
  }

  SplashState copyWith({
    required SplashStatus? status,
    String? error,
  }) {
    return SplashState(
      status: status ?? this._status,
      error: error ?? this._error,
    );
  }
}

enum SplashStatus { initial, loading, loggedIn, loggedOut, error }
