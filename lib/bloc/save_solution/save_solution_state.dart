part of 'save_solution_cubit.dart';

class SaveSolutionState {
  final SaveStatus status;
  final String? error;
  final String? message;

  SaveSolutionState({
    this.status = SaveStatus.initial,
    this.error,
    this.message,
  });

  SaveSolutionState copyWith({
    required SaveStatus? status,
    String? error,
    String? message,
  }) {
    return SaveSolutionState(
      status: status ?? this.status,
      error: error ?? this.error,
      message: message ?? this.message,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SaveSolutionState &&
        other.status == status &&
        other.error == error &&
        other.message == message;
  }

  @override
  int get hashCode => status.hashCode ^ error.hashCode ^ message.hashCode;

  @override
  String toString() =>
      'SaveSolutionState(status: $status, error: $error, message: $message)';
}

enum SaveStatus { initial, loading, success, error }
