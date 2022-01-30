part of 'watch_solution_bloc.dart';

class WatchSolutionState {
  final WatchStatus status;
  final String? error;
  final List<QuestionModel> model;
  WatchSolutionState({
    this.status = WatchStatus.initial,
    this.error,
    this.model = const [],
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WatchSolutionState &&
        other.status == status &&
        other.error == error &&
        listEquals(other.model, model);
  }

  @override
  int get hashCode => status.hashCode ^ error.hashCode ^ model.hashCode;

  @override
  String toString() =>
      'WatchSolutionState(status: $status, error: $error, model: $model)';

  WatchSolutionState copyWith({
    required WatchStatus? status,
    String? error,
    List<QuestionModel>? model,
  }) {
    return WatchSolutionState(
      status: status ?? this.status,
      error: error ?? this.error,
      model: model ?? this.model,
    );
  }
}

enum WatchStatus { initial, loading, success, error }
