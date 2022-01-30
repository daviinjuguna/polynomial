part of 'auth_cubit.dart';

class AuthState {
  final AuthStatus _status;
  final String? _error;

  AuthStatus get status => _status;

  String? get error => _error;

  const AuthState({
    AuthStatus status = AuthStatus.initial,
    String? error,
  })  : _status = status,
        _error = error;

  AuthState copyWith({
    required AuthStatus? status,
    String? error,
  }) {
    return AuthState(
      status: status ?? this._status,
      error: error ?? this._error,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthState &&
          runtimeType == other.runtimeType &&
          _status == other._status &&
          _error == other._error;

  @override
  int get hashCode => _status.hashCode ^ _error.hashCode;

  @override
  String toString() {
    return 'AuthState{_status: $_status, _error: $_error}';
  }
}

enum AuthStatus { initial, loading, loaded, error }
